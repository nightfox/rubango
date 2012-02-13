rubango
================

A ruby API wrapper for integrating your rails application with [Totango](http://www.totango.com).

Installation
------------

    gem install rubango # use 'totango' when require-ing

Usage
-----

First, build your client with your API id:

    Totango.srv_id "YOUR_ID_GOES_HERE"

By default, Totango will not make remote calls. It will print a debug message about the URL that would be getting hit. This message can be annoying when testing. To turn the message off, use `Totango::Config`:

    Totango::Config[:suppress_output] = true

To make the remote call to totango.com you must turn the tracker on:

    Totango.on! # you will probably only want to do this in production mode.

You now interact with `Totango.client` to do your bidding:

    Totango.client.track({
      :organization => "Current organization",
      :user => "Current user",
      :activity => "Current activity",
      :module => "Current module"
    })

You can optionally pass a 'Foreign ID' to Activity Events to indicate the Organization’s identifier on foreign systems:

    Totango.client.track({
      :organization => "Current organization",
      :user => "Current user",
      :activity => "Current activity",
      :module => "Current module",
      :ofid => "1234"
    })

By default, Totango will create a new thread to make the remote calls. If you already track the events using a background job, you should use synchronous calls. To turn synchronous calls on, use `Totango::Config`:

    Totango::Config[:synchronous] = true

There is also the option for integration with different ruby frameworks.

### Rails

    class ApplicationController < ActionController::Base
      include Totango::Adapters::Rails

      #...
    end

That will build your tracking code based around a couple of sane defaults. By default it will set the current module to `params[:controller]` and activity to `params[:action]`. If you wish to override the defaults you can do so in your controllers:

    class MyController < ApplictationController
      sp_default :activity, "Whatever you want here"
      # You may also send a Proc object as the value so that it is
      # evaluated in the context of the current controller. For example:
      sp_default :user, proc { method_to_determine_current_user }
    end

To track different actions, you must now tell Totango which actions you would like to track:

    class MyController < ApplictationController
      track :index
      track :show, "Override default activity text here"
      track :edit, :user => "override other defaults in a hash"
      track :destroy, :if => proc { params[:my_boolean] } # Use conditionals to only run tracking based on the eval'd code in the Proc object
    end

### Rolling your own adapter

There are currently adapters for rails and merb, but it is simple to write your own adapter

    module MySPAdapter
      extend Totango::Adapters::Base

      register_adapter :my_adapter
      hook_method :before_hook      # Hook method name that will be called before or after each action
      action_finder :action_name    # Method that determines the current action being hit

      # You can set defaults from here that will be set on the controller class
      # that includes your adapter and all of its subclasses
      sp_default :activity, proc {action_name}
      sp_default :module, proc {controller_name}
    end

TODO
----

* Adapter tests
* JS client integration
