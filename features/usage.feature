Feature: Usage

  Scenario: No Arguments
    When I run `aeolus`
    Then the output should contain:
    """
    Tasks:
      aeolus help [TASK]       # Describe available tasks or one specific task
      aeolus provider          # show provider subcommands
      aeolus provider_account  # show provider account subcommands
    """

  Scenario: Provider
    When I run `aeolus provider`
    Then the output should contain:
    """
    Tasks:
      aeolus provider add PROVIDER_NAME -t, --provider-type=PROVIDER_TYPE  # Add a provider
      aeolus provider help [COMMAND]                                       # Describe subcommands or one specific subco...
      aeolus provider list                                                 # List all providers
    
    Options:
      [--conductor-url=CONDUCTOR_URL]  
      [--username=USERNAME]            
      [--password=PASSWORD]            
      [--format=FORMAT]                # FORMAT can be 'human' or 'machine'
    """

  Scenario: Provider Account
    When I run `aeolus provider_account`
    Then the output should contain:
    """
    Tasks:
      aeolus provider_account add PROVIDER_ACCOUNT_LABEL --credentials-file=CREDENTIALS_FILE -n, --provider-name=PROVID...
      aeolus provider_account help [COMMAND]                                                                           ...
      aeolus provider_account list                                                                                     ...
    
    Options:
      [--conductor-url=CONDUCTOR_URL]  
      [--username=USERNAME]            
      [--password=PASSWORD]            
      [--format=FORMAT]                # FORMAT can be 'human' or 'machine'
    """

  Scenario: Provider Help List
    When I run `aeolus provider help list`
    Then the output should contain:
    """
    Usage:
      aeolus provider list
    
    Options:
      [--fields=FIELDS]                # Fields (attributes) to print in the listing
      [--conductor-url=CONDUCTOR_URL]  
      [--username=USERNAME]            
      [--password=PASSWORD]            
      [--format=FORMAT]                # FORMAT can be 'human' or 'machine'
    
    List all providers
    """

  Scenario: Provider Help Add
    When I run `aeolus provider help add`
    Then the output should contain:
    """
    Usage:
      aeolus provider add PROVIDER_NAME -t, --provider-type=PROVIDER_TYPE
    
    Options:
      -t, --provider-type=PROVIDER_TYPE                # E.g. ec2, vsphere, mock, rhevm...
          [--deltacloud-url=DELTACLOUD_URL]            
          [--deltacloud-provider=DELTACLOUD_PROVIDER]  
          [--conductor-url=CONDUCTOR_URL]              
          [--username=USERNAME]                        
          [--password=PASSWORD]                        
          [--format=FORMAT]                            # FORMAT can be 'human' or 'machine'

    Add a provider
    """

  Scenario: Provider Account Help List
    When I run `aeolus provider_account help list`
    Then the output should contain:
    """
    Usage:
      aeolus provider_account list
    
    Options:
      [--fields=FIELDS]                # Fields (attributes) to print in the listing
      [--conductor-url=CONDUCTOR_URL]  
      [--username=USERNAME]            
      [--password=PASSWORD]            
      [--format=FORMAT]                # FORMAT can be 'human' or 'machine'
    
    list provider accounts
    """

  Scenario: Provider Account Help Add
    When I run `aeolus provider_account help add`
    Then the output should contain:
    """
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
          [--format=FORMAT]                    # FORMAT can be 'human' or 'machine'
    
    Add a provider account
    """
