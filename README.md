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
1. Blog is refreshed every 15 min, using the Github API to render the markdown
   content as HTML. You can also force the refresh by using the query param
`?secret=CACHE_RESET_TOKEN` when accessing your blog.

We force the application of a specific label since anyone can create issues,
and you don't want people being able to publish anything on your website.

## FAQ

* Why not use the Github Wiki as source?
  The wiki editor does not allow the automatic upload and insertion of assets such as images.

* How secure is it?
  I guess anyone could DoS the system by creating lots of issues, or attempting to access non-existent issues.
