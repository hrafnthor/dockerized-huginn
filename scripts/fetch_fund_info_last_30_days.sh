
#!/bin/bash

# This scripts fetches the market values per day this week for the specific 
# fund that was passed in, and returns the received payload unmodified.

#
# Returns the formatted date at x days difference
#
get_date_diff_x()
{
        echo "$(date --date="$1 day" +%Y-%m-%d)"
}

#
# Returns the formatted date today
#
get_date_now()
{
        echo "$(date +%Y-%m-%d)"
}

if [ $# -ne 2 ]; then
        echo "Error: Two arguments expected!"
        exit 3
else 
        start_date=$(get_date_diff_x -30)
        end_date=$(get_date_now)
        echo | curl "https://api.livemarketdata.com/v1/market_data/v1/funds/$1/history_timeseries/?from_date=$start_date&to_date=$end_date" -H "Authorization$
fi





