thor-cli
========

Revamp of cli tooling for aeolus conductor.  Thor scaffolding is in
place, along with ActiveResource-backed interaction with Conductor's
REST api to list or add providers.

Authentication options for the Conductor api can specified in
~/.aeolus-cli as per the old aeolus client.  Or, /etc/aeolus-cli is
checked if ~/.aeolus-cli does not exist.  Finally, these options may
instead be supplied on the command line with --conductor-url,
--username, and --password.

## Exploring the command and sub command usage

    $ aeolus
    Tasks:
      aeolus help [TASK]       # Describe available tasks or one specific task
      aeolus provider          # show provider subcommands
      aeolus provider_account  # show provider account subcommands

    $ aeolus provider
    Tasks:
      aeolus provider add PROVIDER_NAME -t, --provider-type=PROVIDER_TYPE  # Add a provider
      aeolus provider help [COMMAND]                                       # Describe subcommands or one specific subcommand
      aeolus provider list                                                 # List all providers

    Options:
      [--conductor-url=CONDUCTOR_URL]
      [--username=USERNAME]
      [--password=PASSWORD]

    $ aeolus provider help add
    Usage:
      aeolus provider add PROVIDER_NAME -t, --provider-type=PROVIDER_TYPE

    Options:
      -t, --provider-type=PROVIDER_TYPE                # E.g. ec2, vsphere, mock, rhevm...
          [--deltacloud-url=DELTACLOUD_URL]
          [--deltacloud-provider=DELTACLOUD_PROVIDER]
          [--conductor-url=CONDUCTOR_URL]
          [--username=USERNAME]
          [--password=PASSWORD]

    Add a provider
    $ aeolus provider_account
    Tasks:
      aeolus provider_account add PROVIDER_ACCOUNT_LABEL --credentials-file=CREDENTIALS_FILE -n, --provider-name=PROVIDER_NAME  # Add a provider...
      aeolus provider_account help [COMMAND]                                                                                    # Describe subco...
      aeolus provider_account list                                                                                              # list provider ...

    Options:
      [--conductor-url=CONDUCTOR_URL]
      [--username=USERNAME]
      [--password=PASSWORD]

    $ aeolus provider_account help add
    Usage:
      aeolus provider_account add PROVIDER_ACCOUNT_LABEL --credentials-file=CREDENTIALS_FILE -n, --provider-name=PROVIDER_NAME

    Options:
      -n, --provider-name=PROVIDER_NAME        # (already existing) provider name
          --credentials-file=CREDENTIALS_FILE  # path to credentials xml file
      -q, [--quota=QUOTA]                      # maximum running instances
                                               # Default: unlimited
          [--conductor-url=CONDUCTOR_URL]
          [--username=USERNAME]
          [--password=PASSWORD]

    Add a provider account

## List providers

    $ aeolus provider list
    I, [2012-10-31T14:18:49.411815 #10688]  INFO -- : GET http://localhost:3002/api/providers.xml
    I, [2012-10-31T14:18:49.411966 #10688]  INFO -- : --> 200 OK 5591 (530.6ms)
    Name           Provider Type  Deltacloud Provider  Deltacloud url
    ec2-us-east-1  ec2            us-east-1            http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api
    mock           mock                                http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api
    mock-test1     mock                                http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api
    mock-test9     mock                                http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api

## Add a provider

    $ aeolus provider add mock-test21 --deltacloud-url http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api --provider-type mock
    I, [2012-10-31T14:20:18.522110 #10826]  INFO -- : GET http://localhost:3002/api/provider_types.xml
    I, [2012-10-31T14:20:18.522251 #10826]  INFO -- : --> 200 OK 1060 (432.9ms)
    I, [2012-10-31T14:20:19.314974 #10826]  INFO -- : POST http://localhost:3002/api/providers.xml
    I, [2012-10-31T14:20:19.315100 #10826]  INFO -- : --> 201 Created 254 (707.5ms)
    Provider mock-test21 added with id 23

## Display remote error mesage when trying to add an existing provider

    $ aeolus provider add mock-test21 --deltacloud-url http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api --provider-type mock
    I, [2012-10-31T14:20:24.297438 #10873]  INFO -- : GET http://localhost:3002/api/provider_types.xml
    I, [2012-10-31T14:20:24.297604 #10873]  INFO -- : --> 200 OK 1060 (594.1ms)
    I, [2012-10-31T14:20:24.919177 #10873]  INFO -- : POST http://localhost:3002/api/providers.xml
    I, [2012-10-31T14:20:24.919330 #10873]  INFO -- : --> 422  100 (535.8ms)
    ERROR:  Conductor was unable to save the provider
    ["Provider name has already been taken"]

## Stubs in place for provider_account actions

    $ aeolus provider_account list
    Placeholder to list provider accounts
    $ aeolus provider_account add --provider-name a-provider-name --credentials-file /tmp/account-credentials.xml my_provider_account_name
    Placeholder to add provider account with label my_provider_account_name
    Parameter provider_name is a-provider-name
    Parameter credentials_file is /tmp/account-credentials.xml
    Parameter quota is unlimited
    $
