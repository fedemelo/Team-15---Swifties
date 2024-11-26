//
//  MainView.swift
//  UniTrade
//
//  Created by Federico Melo Barrero on 24/09/24.
//

import SwiftUI
import Firebase

struct MainView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: BottomMenuScreenEnum = .home
    init(
        loginViewModel: LoginViewModel
    ) {
        let appearance = UITabBarAppearance()
        self.loginViewModel = loginViewModel
        loginViewModel.isFirstTimeUser()
        
        appearance.backgroundColor = UIColor(Color.DesignSystem.primary900(for: colorScheme))

        let normalIconColor = UIColor(Color.DesignSystem.contrast900(for: colorScheme))
        appearance.stackedLayoutAppearance.normal.iconColor = normalIconColor
        appearance.inlineLayoutAppearance.normal.iconColor = normalIconColor
        appearance.compactInlineLayoutAppearance.normal.iconColor = normalIconColor

        let selectedIconColor = UIColor(Color.DesignSystem.contrast900(for: colorScheme))
        appearance.stackedLayoutAppearance.selected.iconColor = selectedIconColor
        appearance.inlineLayoutAppearance.selected.iconColor = selectedIconColor
        appearance.compactInlineLayoutAppearance.selected.iconColor = selectedIconColor

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedIconColor]
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedIconColor]
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedIconColor]

        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    let crashLogger = CrashLogger()

    let tabsNamesAndIcons:
    [(title: String, unselectedIcon: String, selectedIcon: String, tag: BottomMenuScreenEnum)] =
    [("Home", "house", "house.fill", .home),
     ("Upload", "plus.circle", "plus.circle.fill", .uploadProduct),
     ("Favorites", "heart", "heart.fill", .favorites),
     ("Profile", "person", "person.fill", .profile)
    ]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabsNamesAndIcons, id: \.tag) {
                tab in tabView(for: tab.tag)
                    .tabItem {
                        TabViewIcon(
                            title: tab.title,
                            unselectedIcon: tab.unselectedIcon,
                            selectedIcon: tab.selectedIcon,
                            isSelected: selectedTab == tab.tag)
                    }
                    .tag(tab.tag)
            }
        }
    }
    
    @ViewBuilder
    func tabView(for tag: BottomMenuScreenEnum) -> some View {
        switch tag {
            case .home:
                NavigationStack {
                    ExplorerView()
                }
            case .uploadProduct:
                NavigationStack {
                    ChooseUploadTypeView()
                }
            case .favorites:
                TemplateView(name: "Favorites")
            case .profile:
                NavigationStack {
                    ProfileView()
                }
        }
    }
}

enum BottomMenuScreenEnum: Hashable {
    case home
    case uploadProduct
    case favorites
    case profile
}
