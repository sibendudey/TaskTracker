# Tasktracker

Design choices

I have three tables.

1. Users
2. tasks
3. timetrackers

-> Users
* Users has a has_many relationship with tasks
* Users has a has_many relationship with timetrackers

-> Tasks
* Task belongs to a single user.
* Task has a has_many relationship with timetrackers

-> Timetrackers

* The purpose of the table was to keep track of the time spent by each user
  on a task. When a task is assigned to a user A and the user A works on the
  task for a certain duration of time before reassigning to another user B, if the
  user B reassigns the task to user A, there should be a way to track the time
  spent by user A on the task. This table fulfills this purpose.

* This table can also be used to show all the tasks that the user has worked upon,
  irrespective of whether the task is currently assigned to the user or not. My web
  application currently doesn't support this feature.


