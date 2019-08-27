# RSpec Deep Eq Matches

This gem adds an RSpec `deep_eq` matcher that recursively compares contents of `Hash` and `Array` data.

## Installation
Add gem to your `Gemfile`:
```ruby
gem 'rspec_deep_eq'
```

And run
```
bundle install
```

Or install it manually:
```bash
gem install rspec_deep_eq
```

## Getting started
In `rails_helper` file, configure `deep_eq` matcher for RSpec:

```ruby
# rails_helper.rb

require 'deep_eq'

RSpec.configure do |config|
  config.include DeepEq
end

```

## Usage
You can compare everything with `deep_eq` matcher, but it's created to compare complex structures like nested hashes and arrays.

```ruby
describe 'Deep Equal' do
  it 'compares' do
    data = prepare_data

    expect(data).to deep_eq(
      id: 1,
      items: [
        id: 3,
        images: [
          {
            url: 'https://example.com/bass_guitar.png'
          },
          {
            url: 'https://example.com/naked_lady.png'
          }
        ]
      ],
      author: {
        name: 'John Doe'
      }
    )
  end
end
```

## Motivation
Comparing complex data structures can be easily done using built-in RSpec matchers like `eq`, `match_array` or `hash_including`. But when something goes wrong, it displays hard-to-read error output. This matcher is created to make fixing such tests easier.

Read more [here](MOTIVATION.md).

## License
Published under MIT license.
