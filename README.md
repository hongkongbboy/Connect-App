Group Project - README
===

# Konnect

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
An intermediary social media platform which allows for a quick and efficient way to connect with friends, family, or new acquaintances across multiple social media platforms. 

### App Evaluation

- **Category:** Social Networking
- **Mobile:** This app would primarily be focused on iOS users but would perhaps extend to other environments and platforms such as devices running on the Android firmware and on computers. This app wouldn't be functionally only limited to running on mobile devices.
- **Story:** Searches and connects users with friends, family, or new acquaintances across multiple social media platforms.
- **Market:** Any individual whom uses social media.
- **Habit:** App usage would depend on the social life of user.
- **Scope:** Our core focus would be to connect users with friends, family, or new acquaintances in a quick and efficient manner. As our user base increases, we will look into expanding our app to becoming a social media platform of its own.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] **Login & Sign Up**
    - [x] User can sign up to create a new account
    - [x] User can log in
    - [x] User can log out
    - [x] User stays logged in across restarts
 
- [ ] **Feed**
    - [x] Feed post of when two users became friends
    - [x] Feed post of when a friend adds or edits their social media
    - [ ] User can load past feed post infinitely
    - [ ] User can click on the feed cell to see the profile details page of the connected user

- [x] **Contact**
    - [x] User can search for friends
    - [x] User can send friend request
    - [x] User can receive friend request
    - [x] User can accept friend request
    - [x] User can decline friend request
    - [x] User can delete friends
    - [x] User can view a list of people whom the user has already connected with

- [ ] **Profile**
    - [ ] User can edit their user profile
    - [ ] User can add a profile picture
    - [x] User can add their social media accounts

- [ ] **UI/UX**
    - [x] User sees app icon in home screen
    - [ ] User sees styled launch screen
    - [x] Add custom icons and placeholders for buttons and image views

- [ ] **Miscellaneous**
    - [x] User can pull to refresh


**Optional Nice-to-have Stories**

- [ ] Using other social media platforms API to instantly follow or add the connected user on that social media platform with a single click on our app
- [ ] User can scan a QR code to connect with other users
- [ ] User can configure their application preferences such as enabling or disabling Dark Mode, control their notification settings, and change their accessbility
- [ ] User can direct message other contacts and vice versa
- [ ] User can create a group chat with users in his contacts
- [ ] User can make a single post on our app to post onto all of the social media platforms that the user has included in their user profile
- [ ] User can use the scheduling feature on our app to schedule when you and your contacts are available to meetup based on the schedules of users default calendar app (Google Calendar or stock iOS calendar app)

### 2. Screen Archetypes

* Login Screen
   * User can login
* Registration Screen
   * User can create a new account
* Stream (Feed) Screen
   * User can view a feed of connected users status and activities. For example, if you are connected with John and he added a new social media platform to his profile, then in your feed, you'll see the message, "John has added a Snapchat account"
   * User can click on the feed cell to see the profile details page of the connected user
* Contact Screen
   * User can view a list of people whom the user has already connected with
   * User can disconnect with other users
* Add Contact Screen
   * User can connect with other users
* Search Screen
   * User can search for other users
* Contact Details Screen
   * User can view the connected contacts profile details, which would include their display name, username (Konnect handle), and a list of social media account usernames
* Profile Screen
   * User can edit their account informations such as their display name, changing their passwords, and editing the list of social media accounts that the user uses
* Settings Screen
   * User can configure their application preferences such as enabling or disabling Dark Mode, control their notification, and change their accessbility, user can delete their account, user can change their password.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Feed tab
* Contact tab
* Profile tab

**Flow Navigation** (Screen to Screen)

* Login Screen
   * Feed Screen
* Registration Screen
   * Feed Screen
* Feed Screen
   * Contact Details Screen
* Contact Screen
   * Add Contact Screen
   * Contact Details Screen
* Add Contact Screen
   * Contact Screen
* Search Screen
   * Contact Screen
   * Add Contact Screen
* Contact Details Screen
   * Contact Screen
* Profile Screen
   * None 
* Settings Screen
   * Feed Screen

## Wireframes
<img src="https://i.imgur.com/urE1J5yl.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups
<img src="https://i.imgur.com/6FByLX5.jpg" width=1000>

### [BONUS] Interactive Prototype
<img src="http://g.recordit.co/QE2YsyApF4.gif" width=600>

## Schema 

### Models

#### User

| Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user (default field) |
   | createdAt     | DateTime | date when account was created (default field) |
   | updatedAt     | DateTime | date when account profile was updated (default field) |
   | username    | String    | account identifer and platform handle |
   | password    | String    | secret word or phrase that must be used to gain access to customers account |
   | emailAddress    | String    | email address connected to username that can be used as login |
   | displayName    | String    | name that is displayed on platform |
   | profileImage    | File    | image that represents user across platform |
   | social    | Array of Strings    | list of social media accounts connected to user account |
   | contacts    | Array of Users    | list of contacts associated with a social networking website |
   | lastLogin    | DateTime    | last time someone has logged into this account


#### Post

| Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| feed comment author |
   | comment       | String   | message from feed |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |

### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

#### List of network requests by screen

- #### Login Screen
  - (Read/GET) Logging In

```swift
  PFUser.logInWithUsernameInBackground("myname", password:"mypass") {
  (user: PFUser?, error: NSError?) -> Void in
  if user != nil {
    // Do stuff after successful login.
  } else {
    // The login failed. Check error to see why.
  }
}
```

- #### Register Screen
  - (Create) Signing up a new account

```swift
  func myMethod() {
  var user = PFUser()
  user.username = "myUsername"
  user.password = "myPassword"
  user.email = "email@example.com"
  // other fields can be set just like with PFObject
  user["phone"] = "415-392-0202"

  user.signUpInBackgroundWithBlock {
    (succeeded: Bool, error: NSError?) -> Void in
    if let error = error {
      let errorString = error.userInfo["error"] as? NSString
      // Show the errorString somewhere and let the user try again.
    } else {
      // Hooray! Let them use the app now.
    }
  }
}
```

- #### Feed Screen
  - (Read/GET) Query all posts where user is author
 
```swift
let query = PFQuery(className:"Post")
query.whereKey("author", equalTo:"Sean Plott")
query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
    if let error = error {
        // Log details of the failure
        print(error.localizedDescription)
    } else if let objects = objects {
        // The find succeeded.
        print("Successfully retrieved \(objects.count) scores.")
        // Do something with the found objects
        for object in objects {
            print(object.objectId as Any)
        }
    }
}
```

- #### Contact (List)
  - (Read/GET) Query all contacts where user is author
  
```swift
let query = PFQuery(className:"list")
query.whereKey("author", equalTo:"Sean Plott")
query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
    if let error = error {
        // Log details of the failure
        print(error.localizedDescription)
    } else if let objects = objects {
        // The find succeeded.
        print("Successfully retrieved \(objects.count) scores.")
        // Do something with the found objects
        for object in objects {
            print(object.objectId as Any)
        }
    }
}
```

- #### Contact (Individual Detail)
  - (Read/GET) Query all details of a certain contact where user is author.

```swift
let query = PFQuery(className:"list")
query.whereKey("author", equalTo:"Sean Plott")
query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
    if let error = error {
        // Log details of the failure
        print(error.localizedDescription)
    } else if let objects = objects {
        // The find succeeded.
        print("Successfully retrieved \(objects.count) scores.")
        // Do something with the found objects
        for object in objects {
            print(object.objectId as Any)
        }
    }
}
```

- #### Contact (QR Method)
  - (Create/POST) Add new contacts to author's contact list.

```swift
// Assume PFObject *myPost was previously created.
// Using PFQuery
let query = PFQuery(className: "Comment")
query.whereKey("post", equalTo: myPost)
query.findObjectsInBackground { (comments: [PFObject]?, error: Error?) in
    if let error = error {
        // The request failed
        print(error.localizedDescription)
    } else {
        // comments now contains the comments for myPost
    }
}

// Using NSPredicate
let predicate = NSPredicate(format: "post = %@", myPost)
let query = PFQuery(className: "Comment", predicate: predicate)

query.findObjectsInBackground { (comments: [PFObject]?, error: Error?) in
    if let error = error {
        // The request failed
        print(error.localizedDescription)
    } else {
        // comments now contains the comments for myPost
    }
}
```

- #### Contact (Manual Entry)
  - (Update/PUT) Add new contacts to author's contact list.

```swift
let query = PFQuery(className:"GameScore")
query.getObjectInBackground(withId: "xWMyZEGZ") { (gameScore: PFObject?, error: Error?) in
    if let error = error {
        print(error.localizedDescription)
    } else if let gameScore = gameScore {
        gameScore["cheatMode"] = true
        gameScore["score"] = 1338
        gameScore.saveInBackground()
    }
}
```

- #### Profile
  - (Update/PUT) Author can update his own personal account details.
 
```swift
let query = PFQuery(className:"GameScore")
query.getObjectInBackground(withId: "xWMyZEGZ") { (gameScore: PFObject?, error: Error?) in
    if let error = error {
        print(error.localizedDescription)
    } else if let gameScore = gameScore {
        gameScore["cheatMode"] = true
        gameScore["score"] = 1338
        gameScore.saveInBackground()
    }
}
```

#### Milestone 2 - Video Walkthrough

Here's a progress video walkthrough of implemented user stories:

<img src='http://g.recordit.co/OmtdCKBLik.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

#### Milestone 1 - Video Walkthrough

Here's a progress video walkthrough of implemented user stories:

<img src='https://i.imgur.com/rkQDloI.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


<img src='https://i.imgur.com/g1Ozx9p.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
