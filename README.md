# RSpec Deep Eq Matches

This gem adds an RSpec `deep_eq` matcher that recursively compares contents of `Hash` and `Array` data.

## Usage

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
