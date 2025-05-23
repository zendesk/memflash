[![Build Status](https://github.com/zendesk/memflash/workflows/test/badge.svg?branch=main)](https://github.com/zendesk/memflash/actions)

Memflash is a gem which enables storing really long values in the Rails FlashHash
without writing them to the session. Instead, it transparently uses `Rails.cache`, thus
enabling the flash in your actions to contain large values, and still fit in a cookie-based
session store.

## How do I use it?

Memflash is completely transparent -- requiring the gem automatically enhances FlashHash
with caching-enabled reads and writes.

By default, any message that is over 300 characters long, will be saved in Rails.cache,
and a pointer to it stored in the flash. You can change this anywhere in your app by:

```ruby
Memflash.threshold = #{length-at-which-writing-to-the-cache-is-trigerred}
```

## How does it work?

Memflash ties into the `[]` and `[]=` methods of Rails's FlashHash. On writes, if the value
being written has a length over Memflash.threshold, Memflash generates a pseudo-random
key for it, writes the pseudo-random key and original value to `Rails.cache`, and stores
the original key and pseudo-random key in the flash. Conceptually, when you write
`flash[:error] = "some message"`, this is equivalent to:

```ruby
if "some message".length >=  Memflash.threshold
  # generate a psedudo-random key, memflash_key
  # write memflash_key, "some message" to Rails.cache
  # write :error, memflash_key to the flash
else
  # write :error, "some message" to the flash, as usual
end
```

On the flip side, reading from the flash, `flash[:error]` is conceptually equivalent to:

```ruby
if the value for :error stored in the flash is a memflash key
  # read the original (large) value from Rails.cache
  # return the original (large) value
else
  # return the value stored in the flash, as usual
end
```

### Releasing a new version
A new version is published to RubyGems.org every time a change to `version.rb` is pushed to the `main` branch.
In short, follow these steps:
1. Update `version.rb`,
2. update version in all `Gemfile.lock` files,
3. merge this change into `main`, and
4. look at [the action](https://github.com/zendesk/memflash/actions/workflows/publish.yml) for output.

To create a pre-release from a non-main branch:
1. change the version in `version.rb` to something like `1.2.0.pre.1` or `2.0.0.beta.2`,
2. push this change to your branch,
3. go to [Actions → “Publish to RubyGems.org” on GitHub](https://github.com/zendesk/memflash/actions/workflows/publish.yml),
4. click the “Run workflow” button,
5. pick your branch from a dropdown.

## Author

Authored by [Vladimir Andrijevik](mailto:vladimir@zendesk.com)

## Copyright and license

Copyright 2013 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
