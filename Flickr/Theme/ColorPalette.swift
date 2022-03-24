//
//  ColorPalette.swift
//  Flickr
//
//  Created by Ananth Desai on 23/03/22.
//

import Foundation
import UIKit

struct ColorPallete {
    let navigationBarBackground: UIColor
    let navigationBarTitleColor: UIColor
    let viewBackgroundColor: UIColor
    let tabBarBackground: UIColor
    let tabBarButtonColor: UIColor
    let searchBarTintColor: UIColor
    let searchBarBackgroundColor: UIColor
    let searchBarIconColor: UIColor
    let searchButtonEnbledBackground: UIColor
    let searchButtonDisabledBackground: UIColor
    let favoritesDefaultTextColor: UIColor

    static let light: ColorPallete = .init(
        navigationBarBackground: UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94),
        navigationBarTitleColor: UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0),
        viewBackgroundColor: UIColor.white,
        tabBarBackground: UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94),
        tabBarButtonColor: UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0),
        searchBarTintColor: UIColor(red: 0.952, green: 0.219, blue: 0.474, alpha: 1.0),
        searchBarBackgroundColor: UIColor(red: 0.462, green: 0.462, blue: 0.501, alpha: 0.02),
        searchBarIconColor: UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.0),
        searchButtonEnbledBackground: UIColor(red: 0, green: 0.835, blue: 0.498, alpha: 1),
        searchButtonDisabledBackground: UIColor(red: 0, green: 0.835, blue: 0.498, alpha: 0.5),
        favoritesDefaultTextColor: UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.0)
    )

    static let dark: ColorPallete = .init(
        navigationBarBackground: UIColor(red: 0.113, green: 0.113, blue: 0.113, alpha: 0.94),
        navigationBarTitleColor: UIColor(red: 0.764, green: 0.176, blue: 0.686, alpha: 1.0),
        viewBackgroundColor: UIColor(red: 0.070, green: 0.07, blue: 0.07, alpha: 0.07),
        tabBarBackground: UIColor(red: 0.086, green: 0.086, blue: 0.086, alpha: 0.94),
        tabBarButtonColor: UIColor(red: 0.764, green: 0.176, blue: 0.686, alpha: 1.0),
        searchBarTintColor: UIColor(red: 0.921, green: 0.921, blue: 0.960, alpha: 0.6),
        searchBarBackgroundColor: UIColor(red: 0.070, green: 0.07, blue: 0.07, alpha: 0.07),
        searchBarIconColor: UIColor(red: 0.921, green: 0.921, blue: 0.960, alpha: 0.6),
        searchButtonEnbledBackground: UIColor(red: 0.870, green: 0.733, blue: 0.388, alpha: 1.0),
        searchButtonDisabledBackground: UIColor(red: 0.870, green: 0.733, blue: 0.388, alpha: 0.5),
        favoritesDefaultTextColor: UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.0)
    )

    @available(iOS 13.0, *)
    static let adaptive: ColorPallete = .init(
        navigationBarBackground: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.navigationBarBackground : ColorPallete.dark.navigationBarBackground
        }),

        navigationBarTitleColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.navigationBarTitleColor : ColorPallete.dark.navigationBarTitleColor
        }),

        viewBackgroundColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.viewBackgroundColor : ColorPallete.dark.viewBackgroundColor
        }),

        tabBarBackground: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.tabBarBackground : ColorPallete.dark.navigationBarBackground
        }),

        tabBarButtonColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.tabBarButtonColor : ColorPallete.dark.tabBarButtonColor
        }),
        searchBarTintColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.searchBarTintColor : ColorPallete.dark.searchBarTintColor
        }),
        searchBarBackgroundColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.searchBarBackgroundColor : ColorPallete.dark.searchBarBackgroundColor
        }),
        searchBarIconColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.searchBarIconColor : ColorPallete.dark.searchBarIconColor
        }),
        searchButtonEnbledBackground: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.searchButtonEnbledBackground : ColorPallete.dark.searchButtonEnbledBackground
        }),
        searchButtonDisabledBackground: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.searchButtonDisabledBackground : ColorPallete.dark.searchButtonDisabledBackground
        }),
        favoritesDefaultTextColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .light ? ColorPallete.light.favoritesDefaultTextColor : ColorPallete.dark.favoritesDefaultTextColor
        })
    )
}

func returnColorPalette() -> ColorPallete {
    if #available(iOS 13.0, *) {
        return ColorPallete.adaptive
    } else {
        // Fallback on earlier versions
        return ColorPallete.light
    }
}
