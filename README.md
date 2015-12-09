# ebarnouflant

An experiment in running a blog based off Github issues.

## Why ?

I usually use octopress to write blog posts, but it's a bit of a pain to quickly preview stuff, commit a new article, or upload images.

Github issues have all that functionality already present, and I like the writing process there.

So I figured, why not write blog posts as Github issues, and have a small blog
engine take the content from there?

## How it works

1. Deploy the app using the Heroku button, set `GITHUB_REPO` to the name of the
   repo you want to use.
1. Write stuff in Github issues of the `GITHUB_REPO` repo..
1. When you're ready to publish an issue as a blog post, you close the issue
   and apply the `published` label.
1. Blog entries are cached for 15 minutes, and the markdown content is cached
   based on the SHA digest of the issue's body. If you need to force a refresh
sooner, just force-refresh the page in your browser (i.e. send `Cache-Control:
no-cache`). Force-refresh requests are throttled so that you can force-refresh
at most every 15 seconds.
1. Your visitors can comment on the corresponding Github issue.

Note: We force the application of a specific label since anyone can create
issues, and you don't want people being able to publish anything on your
website.

## Options

You should probably register a Github application to increase the API
rate-limit (defaults to 60 req/s for anonymous requests):
https://github.com/settings/applications. Then, set `GITHUB_CLIENT_ID` and
`GITHUB_CLIENT_SECRET`.

For the list of supported options, please see the [`app_config.rb`][appconfig]
initializer.

[appconfig]: (https://github.com/crohr/ebarnouflant/blob/HEAD/config/initializers/app_config.rb)

## FAQ

* Why not use the Github Wiki as source?
  The wiki editor does not allow the automatic upload and insertion of assets such as images.
