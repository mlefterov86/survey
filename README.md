# README
#### Rails version 7.1.
#### Ruby version 3.2.2
#### Database MySQL

## Installation
* clone [repository](https://github.com/mlefterov86/rock_paper_scissors)
* navigate to the created directory
* install ruby 3.2.2
* install bundles -> `bundle intall`
* adapt `database.yml` and provide your localhost credentials
* create DB and seeds
  * `rails db:create` -> create DB `poll_development`
  * `rails db:migrate` -> migrate DB tables
  * `rails db:seed` -> generates initial dummy data to populate entries into DB
* run unit test locally `bundle exec rspec` (OPTIONAL) - provides unit tests suit

## Running the project
Project intents to provide survey functionality.
Surveys (polls) are managed via admin `http://localhost:3000/admin` (`activeadmin` gem used).
You can login using the pre-seeded admin user `admin@example.com`, with password `password`.
In the admin you can observe several sections:
* Polls -> where you can create/update/view polls information
  * cannot create a poll with state `published` initially, I have the assumption a new poll should be reviewed first
  * publishing a poll should have min of 2 questions
  * cannot edit a `published` poll, you have to change the state in terms to update it
  * only `published` polls are exposed (viewable) to the outside world
  * you can vote on a poll by visiting its URL address, for example `http://localhost:3000/poll/5` (we can use slugs instead of ids in future)
  * you can visit a `published` from the admin - will display the corresponding view depending if you customer (by IP) already voted for the current flow. You will have 3 options viewing the form
    * Poll not found view will be rendered if poll is not published (not allowed from admin, but you can observe different polls by changing the URL)
    * You will be able to vote if you didn't
    * If you did vote - vote results will be shown
* Questions -> where you can create/update/view questions information
  * edit a questions, belonging to at least one poll is not allowed
* Customers -> where you can view customers information
  * a customer is created ones he/she votes on a poll
  * customer is created by IP address
  * a customer can vote only once per poll
