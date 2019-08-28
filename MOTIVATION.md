# RSpec Deep Eq matcher - motivation
Consider such a test, comparing two hashes:

```ruby
it 'compares' do
  data = {
    room: {
      people: {
        admin: {
          age: 25,
          phone: '000-000-0000',
          name: 'Paul'
        },
        users: [
          { age: 25, phone: '000-000-0000', name: 'John' },
          { age: 25, phone: '000-000-0000', name: 'Tim' },
          { age: 25, phone: '000-000-0000', name: 'George' },
          { age: 25, phone: '000-000-0000', name: 'Jennifer' },
          { age: 25, phone: '000-000-0000', name: 'Kate' },
          { age: 25, phone: '000-000-0000', name: 'Phoebe' },
          { age: 25, phone: '000-000-0000', name: 'James' }
        ]
      }
    }
  }

  expect(data).to eq(
    room: {
      people: {
        admin: {
          age: 25,
          phone: '000-000-0000',
          name: 'Paul'
        },
        users: [
          { age: 25, phone: '000-000-0000', name: 'John' },
          { age: 25, phone: '000-000-0000', name: 'Timothy' },
          { age: 25, phone: '000-000-0000', name: 'George' },
          { age: 25, phone: '000-000-0000', name: 'Jennifer' },
          { age: 25, phone: '000-000-0000', name: 'Kate' },
          { age: 25, phone: '000-000-0000', name: 'Phoebe' },
          { age: 25, phone: '000-000-0000', name: 'James' }
        ]
      }
    }
  )
end
```

I can tell you, the only difference between those two is second users's name. We expect "Tim" to equal "Timothy", which obviously isn't. Look what we got in output, when we use `eq` matcher:

![image](https://user-images.githubusercontent.com/9076315/63783326-1c5a6000-c8ed-11e9-9c6f-5ce237e3ec9d.png)

Now we cannot really see what's wrong, we need to find a special way to do it. Here comes `deep_eq` matcher. Let's use it in our test:

```ruby
it 'compares' do
  data = {
    # omitted for clearance
  }

  expect(data).to deep_eq(
    # omitted for clearance
  )
end
```

Here's what we got now:

![image](https://user-images.githubusercontent.com/9076315/63784137-7871b400-c8ee-11e9-8e35-dc51f90ab87f.png)

Voila, now we see where exactly is the error, we can quickly fix it and enjoy rest of evening.
