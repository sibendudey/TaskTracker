# Tasktracker

Design choices

I have four tables.

1. Users
2. tasks
3. timeblocks
4. manages

-> Users
* Users has a has_many relationship with tasks.
* Users has a has_many relationship with timeblocks.
* Users has a has_many relationship with manages.

-> Tasks
* Task belongs to a single user.
* Task has a has_many relationship with timeblocks.

-> Timeblocks

* A single timeblock belongs to both user and a task. 
* Timeblocks can be edited in UTC time format.
* Timeblocks can be created using "Start Working" button,
  which shows "Stop working" after it has been pressed.
* Once "Stop working" is pressed, a new time block record is created
  having the fields "starttime" and "endtime" along with task_id and user_id.
* Timeblocks can be deleted using the edit page of a task.

-> Manages

* A Manage record belongs to a manager (user) and a managee(user).

