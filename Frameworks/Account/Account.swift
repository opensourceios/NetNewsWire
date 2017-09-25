//
//  Account.swift
//  DataModel
//
//  Created by Brent Simmons on 7/1/17.
//  Copyright © 2017 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import RSCore
import Data
import RSParser
import Database

public enum AccountType: Int {

	// Raw values should not change since they’re stored on disk.
	case onMyMac = 1
	case feedly = 16
	case feedbin = 17
	case feedWrangler = 18
	case newsBlur = 19
	// TODO: more
}

public final class Account: DisplayNameProvider, Hashable {

	public let accountID: String
	public let type: AccountType
	public var nameForDisplay = ""
	public let delegate: AccountDelegate
	public let hashValue: Int
	let settingsFile: String
	let dataFolder: String
	let database: Database
	var topLevelObjects = [AnyObject]()
	var feedIDDictionary = [String: Feed]()
	var username: String?
	var refreshInProgress = false
	
	init?(dataFolder: String, settingsFile: String, type: AccountType, accountID: String) {

		switch type {
			
		case .onMyMac:
			self.delegate = LocalAccountDelegate()
		default:
			return nil
		}

		self.accountID = accountID
		self.type = type
		self.settingsFile = settingsFile
		self.dataFolder = dataFolder
		self.hashValue = accountID.hashValue
		
		let databaseFilePath = (dataFolder as NSString).appendingPathComponent("DB.sqlite3")
		self.database = Database(databaseFilePath: databaseFilePath, accountID: accountID)
	}
	
	// MARK: - API

	public func refreshAll() {

		delegate.refreshAll(for: self)
	}

	func update(_ feed: Feed, with parsedFeed: ParsedFeed, _ completion: RSVoidCompletionBlock) {

		// TODO
	}

	public func markArticles(_ articles: Set<Article>, statusKey: String, flag: Bool) {
	
		database.mark(articles, statusKey: statusKey, flag: flag)
	}
	
	public func ensureFolder(with name: String) -> Folder? {
		
		return nil //TODO
	}

	public func canAddFeed(_ feed: Feed, to folder: Folder?) -> Bool {

		// If folder is nil, then it should go at the top level.
		// The same feed in multiple folders is allowed.
		// But the same feed can’t appear twice in the same folder
		// (or at the top level).

		return true // TODO
	}

	public func addFeed(_ feed: Feed, to folder: Folder?) -> Bool {

		// Return false if it couldn’t be added.
		// If it already existed in that folder, return true.

		return true // TODO
	}

	public func canAddFolder(_ folder: Folder, to folder: Folder?) -> Bool {

		return false // TODO
	}

	public func addFolder(_ folder: Folder, to folder: Folder?) -> Bool {

		return false // TODO
	}

	public func importOPML(_ opmlDocument: RSOPMLDocument) {
	
		// TODO
	}
	
	// MARK: - Equatable

	public class func ==(lhs: Account, rhs: Account) -> Bool {

		return lhs === rhs
	}
}


extension Account: PlistProvider {
	
	public func plist() -> AnyObject? {
		return nil // TODO
	}
}

extension Account: OPMLRepresentable {

	public func OPMLString(indentLevel: Int) -> String {

		var s = ""
		for oneObject in topLevelObjects {
			if let oneOPMLObject = oneObject as? OPMLRepresentable {
				s += oneOPMLObject.OPMLString(indentLevel: indentLevel + 1)
			}
		}
		return s
	}
}
