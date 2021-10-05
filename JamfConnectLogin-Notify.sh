#!/bin/bash
DEP_NOTIFY_LOG="/var/tmp/depnotify.log"
JAMF_BINARY="/usr/local/bin/jamf"

# Service branding, please see the Customized Self Service Branding area below
  BANNER_IMAGE_PATH="/usr/local/myorg/myorg_logo.png"

# Update the variable below replacing "Organization" with the actual name of your organization. Example "ACME Corp Inc."
  ORG_NAME="myorg"

# Main heading that will be displayed under the image
# If this variable is left blank, the generic banner will appear
  BANNER_TITLE="Welcome to $ORG_NAME"

# Paragraph text that will display under the main heading. For a new line, use \n
# If this variable is left blank, the generic message will appear. Leave single
# quotes below as double quotes will break the new lines.
  MAIN_TEXT='We want you to have a few applications and settings configured before you get started with your new Mac. This process should take 10 to 20 minutes to complete. \n \n If you need additional software or help, please visit the Self Service app in your Applications folder.'

# Initial Start Status text that shows as things are firing up
  INITAL_START_STATUS="Initial Configuration Starting..."

# Text that will display in the progress bar
  INSTALL_COMPLETE_TEXT="Configuration Complete!"

#########################################################################################
# Trigger to be used to call the policy
#########################################################################################
# Policies can be called be either a custom trigger or by policy id.
# Select either event, to call the policy by the custom trigger,
# or id to call the policy by id.
TRIGGER="event"

#########################################################################################
# Policy Variable to Modify
#########################################################################################
# The policy array must be formatted "Progress Bar text,customTrigger". These will be
# run in order as they appear below.
  POLICY_ARRAY=(
    "Checking for Apple Silicon and enabling Rosetta2,rosetta2"
    "Setting the TimeZone,timezone"
    "Setting a Firmware Password,fwcheck"
    "Installing Google Chrome,chrome"
    "Installing Microsoft Office,msoffice"
    "Installing VLC,vlc"
    "Installing Zoom,zoom"
    "Checking & Installing software from any other remaining policies,jamf-policy"
    "Preinstaller Cleanup,jamfconnectlogin-notify-cleanup"
  )




# Setting custom image if specified
  if [ "$BANNER_IMAGE_PATH" != "" ]; then  echo "Command: Image: $BANNER_IMAGE_PATH" >> "$DEP_NOTIFY_LOG"; fi

# Setting custom title if specified
  if [ "$BANNER_TITLE" != "" ]; then echo "Command: MainTitle: $BANNER_TITLE" >> "$DEP_NOTIFY_LOG"; fi

# Setting custom main text if specified
  if [ "$MAIN_TEXT" != "" ]; then echo "Command: MainText: $MAIN_TEXT" >> "$DEP_NOTIFY_LOG"; fi

# Adding nice text and a brief pause for prettiness
  echo "Status: $INITAL_START_STATUS" >> "$DEP_NOTIFY_LOG"
  sleep 3

# Setting the status bar
  # Counter is for making the determinate look nice. Starts at one and adds
  # more based on EULA, register, or other options.
    ADDITIONAL_OPTIONS_COUNTER=1
  
  # Checking policy array and adding the count from the additional options above.
    ARRAY_LENGTH="$((${#POLICY_ARRAY[@]}+ADDITIONAL_OPTIONS_COUNTER))"
    echo "Command: Determinate: $ARRAY_LENGTH" >> "$DEP_NOTIFY_LOG"



  # Loop to run policies
  for POLICY in "${POLICY_ARRAY[@]}"; do
    echo "Status: $(echo "$POLICY" | cut -d ',' -f1)" >> "$DEP_NOTIFY_LOG"
    "$JAMF_BINARY" policy "-$TRIGGER" "$(echo "$POLICY" | cut -d ',' -f2)"
  done

  echo "Command: Quit" >> $DEP_NOTIFY_LOG
