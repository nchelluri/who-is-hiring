# who-is-hiring
HackerNews "Who is hiring?" Browser

Creates an HTML page listing all the postings from "Who is hiring?" stories, with buttons to filter for "Remote", "Interns" and "Visa" jobs. Also includes an input box for ad-hoc case-insensitive filtering of posts using JS regular expressions, the ability to remove posts from the listing, and the ability to restore all deleted posts.

Fetches data from the HN Firebase API.

All data is stored locally. No data about any filters you use, links you click, posts you remove from the listing, etc., are ever sent anywhere. There are no analytics.

Run it by typing `./generate.rb`. It will generate a file called `who-is-hiring.html` that you can view in your web browser. You can add the `--refresh` parameter to refresh this month's data.
