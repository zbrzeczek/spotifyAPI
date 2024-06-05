#!/bin/bash


spotiAPI() {
	local CO=$1
   	local ID='509dS4Q0EfUQuG7KvaSsiz?si=6cee7b2c19e44d07'

	# Spotify API credentials
	CLIENT_ID="a3dd0e0daf544b2a92f731e7ecfbe696"
	CLIENT_SECRET="e4f7cb751d0343538558086475392f20"

	# Base64 encoded client ID and client secret for authentication
	AUTH=$(echo -n "$CLIENT_ID:$CLIENT_SECRET" | base64)

	# Get access token from Spotify API
	RESPONSE=$(curl -X POST "https://accounts.spotify.com/api/token" \
	     -H "Content-Type: application/x-www-form-urlencoded" \
	     -d "grant_type=client_credentials&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET")

	ACCESS_TOKEN=$(echo $RESPONSE | grep -oP '"access_token":"\K[^"]+')

	USER_PROFILE=$(curl --request GET \
	  --url https://api.spotify.com/v1/$CO/$ID \
	  --header "Authorization: Bearer $ACCESS_TOKEN")
	  
	# Fetch user profile information

	# Print user profile information
	echo "User Profile:"
	echo "$USER_PROFILE"
}



OPTSTRING=":s:a:l:"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    a)
      CO='artists'
      spotiAPI "$CO" "$OPTARG"
      ;;
    s)
      CO='track'
      spotiAPI "$CO" "$OPTARG"
      ;;
    l)
      CO='albums'
      spotiAPI "$CO" "$OPTARG"
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done
