import SwiftUI

enum AppScreen: Hashable, Identifiable, CaseIterable {

    case backyards
    case birds
    case plants

    var id: AppScreen { self }
}

extension AppScreen {
    @MainActor
    @ViewBuilder
    var label: some View {
        switch self {
            case .backyards:
                Label("Backyards", systemImage: "tree")
            case .birds:
                Label("Birds", systemImage: "bird")
            case .plants:
                Label("Plants", systemImage: "leaf")
        }
    }

    @MainActor
    @ViewBuilder
    var destination: some View {
        switch self {
            case .backyards:
                BackyardNavigationStack()
            case .birds:
                BirdsNavigationStack()
            case .plants:
                PlantsNavigationStack()
        }
    }

}

@MainActor
@Observable
class Router {
    var selectedTab: AppScreen
    init(selectedTab: AppScreen) {
        self.selectedTab = selectedTab
    }

    var birdRoutes: [BirdRoute] = [] {
        willSet {
            if selectedTab != .birds {
                selectedTab = .birds
            }
        }
    }

    var plantRoutes: [PlantRoute] = [] {
        willSet {
            if selectedTab != .plants {
                selectedTab = .plants
            }
        }
    }
}

enum PlantRoute {
    case home
    case detail
}

struct Bird: Hashable {
    let name: String
}

enum BirdRoute: Hashable {
    case home
    case detail(Bird)
}

struct BirdsNavigationStack: View {
    @Environment(Router.self) private var router

    var body: some View {
        @Bindable var router = router
        NavigationStack(path: $router.birdRoutes) {
            Button("Go to detail") {
                router.birdRoutes.append(.detail(Bird(name: "Sparrow")))
            }
            .navigationDestination(for: BirdRoute.self) { route in
                switch route {
                    case .home:
                        Text("Home")
                    case .detail:
                        Text("Detail")
                }
            }
        }
    }
}

struct PlantsNavigationStack: View {
    @Environment(Router.self) private var router

    var body: some View {

        @Bindable var router = router

        NavigationStack(path: $router.plantRoutes) {
            Button("Plants Go to detail") {
                router.plantRoutes.append(.detail)
            }
            .navigationDestination(for: PlantRoute.self) { route in
                switch route {
                    case .home:
                        Text("Home")
                    case .detail:
                        Text("Plant Detail")
                    Button("Plants Go to home") {
                        router.plantRoutes = []
                    }
                }
            }
        }
    }
}

struct BackyardNavigationStack: View {
    @Environment(Router.self) private var router

    var body: some View {

        NavigationStack {
            List(1...10, id: \.self) { index in
                NavigationLink {
                    Text("Backyard Detail \(index)")
                    Button("Go to plants") {
                        router.plantRoutes.append(.detail)
                    }
                } label: {
                    Text("Backyard \(index)")
                }
            }
            .navigationTitle("Backyards")
        }
    }
}

struct AppTabView: View {
    @State private var router: Router = Router(selectedTab: .backyards)

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
        .environment(router)
    }
}

struct ContentView: View {
    var body: some View {
        AppTabView()
    }
}

//#Preview {
//    ContentView()
//        .environment(Router(selectedScreen: .constant(nil)))
//}
