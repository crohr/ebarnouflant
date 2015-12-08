# ebarnouflant

An experiment in running a blog based off Github issues.

## Why ?

I usually use octokit to write blog posts, but it's a bit of a pain to quickly preview stuff, commit a new article, or upload images.

Github issues have all that functionality already present, and I like the writing process there.

So I figured, why not write blog posts as Github issues, and have a small blog engine take the content from there?

## How it works

1. Deploy the app using the Heroku button
1. Add a webhook to your repo that points to <http://your-app.com/ping>
1. You write stuff in Github issues.
1. When you're ready to publish, you apply the `published` label.
1. The app then receives a webhook event, and publishes your article, using the Github markdown API to render the issue as HTML.
1. Article content is cached in whatever Rails cache store you're using.
