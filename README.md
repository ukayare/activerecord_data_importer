# ActiverecordDataImporter

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/activerecord_data_importer`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_data_importer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord_data_importer

## Usage

### Basic
please include sentence on ActiveRecord's Model
```
  include ActiverecordDataImporter

```

When you defined model like this
```
class Item < ActiveRecord::Base
  include ActiverecordDataImporter
end 

schema
///////////
  create_table "Items", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end
///////////
```

and exsit file json file like context,
```
[
  { "id": 1, "name": "hoge" },
  { "id": 2, "name": "huga" }
]
```

you'll be able to import the following description(json file path is /foo/bar/items.json).
```
Item.import_from_json "/foo/bar/items.json"
```

If json single object following description, it can be used in the same way.
```
{ "id": 1, "name": "hoge" }
```

### Association support
If you've used association model
example
```

class Item < ActiveRecord::Base
  include ActiverecordDataImporter
  has_many :item_effects
end 

class ItemEffect < ActiveRecord::Base
  include ActiverecordDataImporter
end 

schema
///////////
  create_table "Items", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "Item_effects", force: :cascade do |t|
    t.integer "value", null: false
    t.integer "item_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end
///////////
```
you can import such json structure
```
[
  {
    "id": 1,
    "name": "hoge",
    "item_effects":[
      { "value": 1 },
      { "value": 2 },
      { "value": 3 }
    ]
  },
  {
    "id": 2,
    "name": "huga",
    "item_effects":[
      { "value": 1 },
      { "value": 2 },
      { "value": 3 }
    ]
  },
  {
    "id": 3,
    "name": "piyo",
    "item_effects":[
      { "value": 1 },
      { "value": 2 },
      { "value": 3 }
    ]
  }
]
```
You can also import in the same way if it multistage association in the correct json description.

### Versioning number
If importing target schema has version column, It will be increment automatically each time a record is updated.
But, if same data importing (no change), version is not updated.
Also, having assosiation and updating child association, parent version is updated.
Furthermore, when version is updated, version number is that obtained by adding 1 to the highest number in all data before the update

### csv supporting
csv file format is supported. if you want to use relational structure, please define same row and column name should be dotted
And if relational data is `has_many` structure, please put the serial number before the dot
ex:
csv file
```
id,name,item_effects1.value,item_effects2.value,item_effects3.value
1,hoge,1,2,3
2,huga,1,2,3
3,piyo,1,2,3
```
table showing
| id        | name           | item_effects1.value  | item_effects2.value | item_effects3.value |
| ------------- | ------------- | ------------- | ------------- | ------------- | 
| 1      | hoge  | 1 | 2 | 3 |
| 2      | huga  | 1 | 2 | 3 |
| 3      | piyo  | 1 | 2 | 3 |

## Note that

* If id does not exist json's attributes, new record will be created. As long as it does not want this thing , always please do put the id.
* Case of has_many association existed, always sync import data. Example for previous model structure (item and item_effect), if the effect associated with the item Two importing the data associated with three one state , and is adjusted to two.
```
when before imported data is
  {
    "id": 1,
    "name": "hoge",
    "item_effects":[
      { "value": 1 },
      { "value": 2 },
      { "value": 3 }
    ]
  }
and after is...
  {
    "id": 1,
    "name": "hoge",
    "item_effects":[
      { "value": 1 },
      { "value": 2 }
    ]
  }

the result is that..
Item.find(1).item_effects
>> [#<ItemEffect id: 1, item_id: 1, value: 1, created_at: "2015-09-15 09:32:19", updated_at: "2015-09-15 09:32:19">, #<ItemEffect id: 2, item_id: 1, value: 2, created_at: "2015-09-15 09:32:19", updated_at: "2015-09-15 09:32:19">] 
```
* belong_to assosiasion is not supported
* default versioning is maybe undesirable for you. The reason is that is processing to get the latest version is published full scan query.
 * If you think you undesirable this, this method should be overridden to get the latest version in a different way.
 * ex)
 * using cache store latest version.
 * using model for version information.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/activerecord_data_importer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
