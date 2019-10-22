--[[
  Copyright (C) 2019 "IoT.bzh"
  Author Johann CAHIER <johann.cahier@iot.bzh>

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.


  NOTE: strict mode: every global variables should be prefixed by '_'

  Test commands:
    afb-client-demo 'localhost:2345/api?token=' pushtotalk_controller fake_direction {angle:45}
--]]


-- Dualshock 3
local subscriptions = {
    -- Button X
    ["linux-joystick//dev/input/js0-button0"] = {
        request = { device = "/dev/input/js0", input_type="button", input_id='0' },
        handle = nil,
        can_event = "messages.joystick.button"
    },
    -- left joystick up/down
    ["linux-joystick//dev/input/js0-axis0_x"] = {
        request = { device = "/dev/input/js0", input_type="axis", input_id='0_x' },
        handle = nil,
        can_event = "messages.joystick.axe.y"
    },
    -- left joystick left/right
    ["linux-joystick//dev/input/js0-axis0_y"] = {
        request = { device = "/dev/input/js0", input_type="axis", input_id='0_y' },
        handle = nil,
        can_event = "messages.joystick.axe.x"
    },
    -- right joystick left/right
    ["linux-joystick//dev/input/js0-axis1_x"] = {
        request = { device = "/dev/input/js0", input_type="axis", input_id='1_x' },
        handle = nil,
        can_event = "messages.joystick.axe.z"
    }
}

function _run_onload_(source)
    AFB:notice(source, "--InLua-- ENTER _run_onload_ CTLapp service sample\n")


    for name,subscription in pairs(subscriptions) do
        local err, response =AFB:servsync (source, "linux-joystick", "subscribe", subscription["request"])
        if (err) then
            AFB:error(source, "--inlua-- Cannot subscribe to joystick event: ", name)
            return 1
        end
        subscription["handle"] = AFB:evtmake(source, subscription["can_event"])
    end

    return 0
end



function joystick_event_button0_handler(source, action, event)
    local state
    if (event == "pressed") then
        state = 1
    else
        state = 0
    end

    AFB:evtpush(source, subscriptions["linux-joystick//dev/input/js0-button0"]["handle"], {value = state})
end

function joystick_event_axis0_x_handler(source, action, event)
    AFB:evtpush(source, subscriptions["linux-joystick//dev/input/js0-axis0_x"]["handle"], {value = event/-32.77})
end

function joystick_event_axis0_y_handler(source, action, event)
    AFB:evtpush(source, subscriptions["linux-joystick//dev/input/js0-axis0_y"]["handle"], {value = event/32.77})
end

function joystick_event_axis1_x_handler(source, action, event)
    AFB:evtpush(source, subscriptions["linux-joystick//dev/input/js0-axis1_x"]["handle"], {value = event/32.77})
end

function subscribe(source, args, query)
    for name,subscription in pairs(subscriptions) do
        AFB:subscribe(source, subscription['handle'])
    end
    AFB:notice(source, "--InLua-- subscribe query=%s args=%s", query, args)
    AFB:success(source, response)
end
function unsubscribe(source, args, query)
    for name,subscription in pairs(subscriptions) do
        AFB:unsubscribe(source, subscription['handle'])
    end
    AFB:notice(source, "--InLua-- unsubscribe query=%s args=%s", query, args)
    AFB:success(source, response)
end


