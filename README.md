# Technical Test for Le Collectionist

Let's code a Rails app for a listing rentals management company

1. [Introduction](#1-introduction)
2. [Technical stack](#2-technical-stack)
3. [Setup](#3-setup)
4. [Documentation](#4-documentation)
5. [Spec](#5-spec)

## 1. Introduction

The technical test app serves four mains goal :
  - Create / Update / destroy and Get one or many appartement
  - Create cleaning mission whenever a booking or a reservation is created
  - Delete a cleaning mission  whenever a booking or a reservation is deleted

## 2. Technical stack

The technical test is developped using Ruby on Rails.

### Ruby version (2.7.5)

To install it with `rbenv` please run

```sh
$ rbenv install 2.7.5
```

### Rails version (6.1.6.1)

### Database : PostGreSQL

```sh
# MacOS
brew install postgresql
brew services start postgresql
```

## 3. Setup

### Clone the repository

```sh
git clone git@github.com:adriviv/hostnfly-test.git
cd hostnfly-test
```

### Install dependencies using Bundler and Yarn:

```sh
bundle && yarn
```

### Initialize the database

```sh
rails db:create db:migrate db:seed
```

### Start rails server

```sh
rails server
```

## 4. Documentation
- [ ] INDEX : Listings
`GET http://localhost:3000/api/v1/listings`

- [ ] SHOW : Listing
`GET http://localhost:3000/api/v1/listings/:id`

- [ ] CREATE : Listing
`POST http://localhost:3000/api/v1/listings/:id`

params: 
```
{
	"listing": {
		"num_rooms": 3
	}
}
```

- [ ] UPDATE : Listing
`PUT http://localhost:3000/api/v1/listings/:id`

params: 
```
{
	"listing": {
		"num_rooms": 3
	}
}
```

- [ ] DELETE : Listing
`DELETE http://localhost:3000/api/v1/listings/:id`


- [ ] INDEX : Missions
`GET http://localhost:3000/api/v1/missions`


## 5. Spec

- [ ] As an employee, I can see a specific listing
- [ ] As an employee, I can see a list of listings
- [ ] As an employee, I can create a listing
- [ ] As an employee, I can update the num_rooms of a listing
- [ ] As an employee, I can destroy a listing
- [ ] Whenever a booking is created, a cleaning mission called `first_checkin` is created at the beginning of the booking
- [ ] Whenever a booking is created, a cleaning mission `last_checkout` is created before the owner comes back
- [ ] Whenever a reservation is created, a cleaning mission `checkout_checkin` at the end of each reservation UNLESS there is already a last_checkout at the same date
- [ ] As an employee, when I can see the list of missions. The output JSON should resemble this
```
{
  "missions": [
    {:listing_id=>1, :mission_type=>"first_checkin", :date=>"2016-10-10", :price=>20},
    {:listing_id=>1, :mission_type=>"last_checkout", :date=>"2016-10-15", :price=>10},
    {:listing_id=>1, :mission_type=>"first_checkin", :date=>"2016-10-16", :price=>20},
    {:listing_id=>1, :mission_type=>"last_checkout", :date=>"2016-10-20", :price=>10},
    {:listing_id=>1, :mission_type=>"checkout_checkin", :date=>"2016-10-13", :price=>20},
    {:listing_id=>2, :mission_type=>"first_checkin", :date=>"2016-10-15", :price=>10},
    {:listing_id=>2, :mission_type=>"last_checkout", :date=>"2016-10-20", :price=>5},
    {:listing_id=>2, :mission_type=>"checkout_checkin", :date=>"2016-10-18", :price=>10}
  ]
}
```


If you want to run test locally :

```sh
$ bundle exec rspec
```