## TipOfMyKeyboard

This repository serves as a reference for iOS tricks that are commonly forgotten until you dig up that one project from that one time where you implemented it previously.

### Setup

1. Install [rubygems](https://rubygems.org/pages/download), you probably already have this
1. Install [bundler](https://bundler.io/), you might already have this
1. Install dependencies using bundler

		bundle install

1. Install project dependencies via bundler

        bundle exec pod install

1. Open *TipOfMyKeyboard.xcworkspace*

### Examples

- *SelfSizingCollectionViewController.swift*, an example of self-sizing `UICollectionView` cells and supplementary views
- *NavigationBarTintColorUpdatingViewController.swift*, an example of animating the `barTintColor` property of `UINavigationBar` in a way that supports interactive pop
- *BadgedBackBarButtonItemViewController.swift*, an example of a badged `backBarButtonItem` property of `UINavigationItem`, similar to how the Mail app badges the back item with the number of unread emails