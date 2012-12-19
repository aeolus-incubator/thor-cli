thor-cli
========

Revamp of cli tooling for aeolus conductor.  Thor scaffolding is in
place, along with ActiveResource-backed interaction with Conductor's
REST api to list or add providers.

## Configuration

Connection/auth options for the Conductor API may be specified in a
configuration file in one of three places: the file defined by the
environment variable AEOLUS_CLI_CONF, otherwise ~/.aeolus-cli (if it
exists), otherwise /etc/aeolus-cli (if it exists).  Additionaly,
connection/auth options may be set or overridden from the command line
with --conductor-url, --username and --password.

Logging levels also are set in the configuration file.

    # Sample configuration file
    :conductor:
      :url: http://example.com:3013/api
      :username: master
      :password: ofuniverse
    :logging:
      # one of DEBUG, WARN, INFO, ERROR or FATAL 
      :level: WARN
      # one of STDOUT, STDERR or /path/to/logfile
      :logfile: STDERR

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
    Name           Provider Type  Deltacloud Provider  Deltacloud url
    ec2-us-east-1  ec2            us-east-1            http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api
    mock           mock                                http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api
    mock-test1     mock                                http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api
    mock-test9     mock                                http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api

## Add a provider

    $ aeolus provider add mock-test21 --deltacloud-url http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api --provider-type mock
    Provider mock-test21 added with id 23

## Display remote error mesage when trying to add an existing provider

    $ aeolus provider add mock-test21 --deltacloud-url http://qeblade30.rhq.lab.eng.bos.redhat.com:3002/api --provider-type mock
    ERROR:  Conductor was unable to save the provider
    ["Provider name has already been taken"]

## List provider accounts

    $ aeolus provider_account list
    Name  Provider  Username  Quota
    mock  mock      mockuser  unlimited

## Add a provider account

    $ cat /tmp/credentials.xml
    <credentials>
    <username>mockuser</username>
    <password>mockpassword</password>
    </credentials>
    $ aeolus provider_account add mock --provider-name mock --credentials-file /tmp/credentials.xml
    Provider account mock added with id 2

## Display remote error message when trying to add an existing provider account

    $ aeolus provider_account add mock --provider-name mock --credentials-file /tmp/credentials.xml
    ERROR:  Conductor was unable to save the provider account
    ["Label has already been taken", "Username has already been taken"]
