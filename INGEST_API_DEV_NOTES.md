# THESE ARE JUST RANDOM NOTES
# DELETE THIS FILE BEFORE CREATING A PR

```
brew install rbenv
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
rbenv install 2.6.1
cd
rbenv local 2.6.1
cdp
gcl git@github.com:splunk/fluent-plugin-splunk-hec.git
cd fluent-plugin-splunk-hec
bundle install
```

Set module ruby SDK to 2.6.1 (may need to restart IntelliJ if it was open)

Then do this stuff
https://confluence.splunk.com/display/PROD/Local+development+with+fluentd+plugin

`gem install fluentd --no-ri --no-rdoc`

To test local changes `rake install:local` and restart fluentd

Changes to Event Format:
```
  time 1433188255.512 => timestamp 1433188255512
  index => nothing
  fields => attributes
  event => body
```

Message formats:

[HEC2](https://sdc.splunkbeta.com/docs/ingest/ingest)

[HEC1](http://dev.splunk.com/view/event-collector/SP-CAAAE6P)


## Steps?

Extract `prepare_payload` from `format_event`

Override `format_event`:
```
    def format_event(tag, time, record)
      payload = prepare_payload(record, tag, time)
      payload[:attributes] = payload[:fields]
      delete payload[:fields]
      // repeat for other keys
      MultiJson.dump(payload)
    end
```

Override new_connection to do oidc stuff
