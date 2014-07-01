require '../lib/totango'

options = {}
options.store(:account_id, 200)
options.store(:account_name, "Some Company")
options.store(:status, "Paying")
options.store(:abcd, "123")
options.store(:user_id, "anirvan.mandal@gmail.com")
options.store(:user_name, "Anirvan")
options.store(:activity, "Random A")
options.store(:module, "Random M")

Totango.client.track(options)
