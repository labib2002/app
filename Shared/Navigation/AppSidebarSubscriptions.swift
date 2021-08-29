import SwiftUI

struct AppSidebarSubscriptions: View {
    @EnvironmentObject<NavigationState> private var navigationState
    @EnvironmentObject<Subscriptions> private var subscriptions

    @Binding var selection: TabSelection?

    var body: some View {
        Section(header: Text("Subscriptions")) {
            ForEach(subscriptions.all) { channel in
                NavigationLink(tag: TabSelection.channel(channel.id), selection: $selection) {
                    ChannelVideosView(channel)
                } label: {
                    Label(channel.name, systemImage: AppSidebarNavigation.symbolSystemImage(channel.name))
                }
                .contextMenu {
                    Button("Unsubscribe") {
                        navigationState.presentUnsubscribeAlert(channel)
                    }
                }
                .alert(unsubscribeAlertTitle, isPresented: $navigationState.presentingUnsubscribeAlert) {
                    if let channel = navigationState.channelToUnsubscribe {
                        Button("Unsubscribe", role: .destructive) {
                            subscriptions.unsubscribe(channel.id)
                        }
                    }
                }
            }
        }
    }

    var unsubscribeAlertTitle: String {
        if let channel = navigationState.channelToUnsubscribe {
            return "Unsubscribe from \(channel.name)"
        }

        return "Unknown channel"
    }
}
