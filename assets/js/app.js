// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"


import $ from "jquery";

// ...

function update_buttons() {
    $('.manage-button').each( (_, bb) => {
        let user_id = $(bb).data('user-id');
    let manage = $(bb).data('manage');
    if (manage != "") {
        $(bb).text("Unmanage");
    }
    else {
        $(bb).text("Manage");
    }
});
}

function set_button(user_id, value) {
    $('.manage-button').each( (_, bb) => {
        if (user_id == $(bb).data('user-id')) {
        $(bb).data('manage', value);
    }
});
    update_buttons();
}

function manage(user_id) {
    let text = JSON.stringify({
        manage: {
            manager_id: current_user_id,
            managee_id: user_id
        },
    });

    $.ajax(manage_path, {
        method: "post",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: text,
        success: (resp) => { set_button(user_id, resp.data.id); },
});
}

function unmanage(user_id, follow_id) {
    $.ajax(manage_path + "/" + follow_id, {
        method: "delete",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: "",
        success: () => { set_button(user_id, ""); },
});
}

function manage_click(ev) {
    let btn = $(ev.target);
    let manage_id = btn.data('manage');
    let user_id = btn.data('user-id');

    if (manage_id != "") {
        unmanage(user_id, manage_id);
    }
    else {
        manage(user_id);
    }
}

function init_follow() {
    if (!$('.manage-button')) {
        return;
    }

    $(".manage-button").click(manage_click);

    update_buttons();
}

function manage_time_click(ev) {
    let btn = $(ev.target);
    let start_time = btn.data('start-time');
    if ( start_time == '')   {
        let date_now = new Date();
        console.log(date_now.toJSON());
        btn.data('start-time', date_now.toJSON());
        btn.text('Stop Working');
    }
    else {
        let btn = $(ev.target);
        let start_time = btn.data('start-time');
        let task_id = btn.data('task-id');
        let user_id = btn.data('user-id');
        create_time_block(start_time, task_id, user_id);
    }
}

function create_time_block(start_time, task_id, user_id) {
    let end_time = new Date().toJSON();
    let text = JSON.stringify({
        timeblock: {
            task_id: task_id,
            user_id: user_id,
            starttime: start_time,
            endtime: end_time
        },
    });

    $.ajax("/api/v1/timeblocks", {
        method: "post",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: text,
        success: (resp) => { reset_button(task_id); },
    });
}

function reset_button(task_id)  {
    $('.time-block').each( (_, bb) => {
        if (task_id == $(bb).data('task-id')) {
            $(bb).data('start-time', "");
            $(bb).text('Start Working');
        }
    });
}

function init_time_tracker()    {
    if (!$(".time-block"))  {return;}
    $(".time-block").click(manage_time_click);
}

$(init_follow);

$(init_time_tracker);
