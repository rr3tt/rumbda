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

## Usage
Ensure target directory has the following files: `main.rb`, `Gemfile`, `Gemfile.lock`.
`main.rb` is the entry point to the ruby script. The `Gemfile` and `Gemfile.lock` are where gems are specified.

### Building the zip

```
rumbda build <directory>
# => creates a file called "index.zip"
```

### Configuring the lambda
0. Set **Runtime** to `Node.js 4.3`.
0. Set **Code entry type** to `Upload a .ZIP file`.
0. In the **Function package** upload `index.zip` (the zip created by `rumbda build <directory>`).
0. Set **Handler** to `index.handler`.
