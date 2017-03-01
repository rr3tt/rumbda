# rumbda
A command line tool to build zip files for running ruby on aws lambda.

## Installation
```
gem install rumbda
```
or add it to the Gemfile

```
group :development do
  gem 'rumbda'
end
```

## What does rumbda do?
rumbda does everything necessary to build a zip file for running ruby inside of an AWS Lambda. This includes downloading [traveling ruby](https://github.com/phusion/traveling-ruby) and creating a bundle of the project's Gemfile dependencies, creating a consumable .zip file for use with Lambda.

## Usage
Ensure target directory has the following files: `main.rb`, `Gemfile`, `Gemfile.lock`.
`main.rb` is the entry point to the ruby script. The `Gemfile` and `Gemfile.lock` are where gems are specified.

### Building the zip

```
rumbda build [directory]
# => creates a file called "index.zip"
```

### Configuring the lambda
0. Set **Runtime** to `Node.js 4.3`.
0. Set **Code entry type** to `Upload a .ZIP file`.
0. In the **Function package** upload `index.zip` (the zip created by `rumbda build <directory>`).
0. Set **Handler** to `index.handler`.

## Example
See the [example folder](example/) for what a project using rumbda might look like.
```
pwd
#=> ~/rumbda/example
ruby --version
#=> 2.2.2
bundle install
#=> installs dependencies, creates Gemfile.lock
bundle exec rumbda build
#=> builds the index.zip file
```
After the index.zip file is built, follow the steps for [configuring the lambda](#configuring-the-lambda).

