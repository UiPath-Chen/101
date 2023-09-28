# yq
---
https://github.com/mikefarah/yq

### Install yq
`snap install yq`
or
`go install github.com/mikefarah/yq/v4@latest`



### 使用

- Read a value:
    `yq '.a.b[0].c' file.yaml`

- Pipe form STDIN
  `yq '.a.b[0].c' < file.yaml`

- Update a yaml file, in place
  `yq '.a.b[0].c = "cool"` file.yaml

- Update using environment variables
  `NAME=mike yq -i '.a.b[0].c = strenv(NAME)' file.yaml`

- Merge multiple file
  note the use of `ea` to evaluate all the files at once instead of in sequence
  `yq ea '. as $item ireduce ({}; . * $item )' path/to/*.yml`

- Multiple updates to a yaml file
  `yq -i '
      .a.b[0].c = "cool" |
      .x.y.z = "foobar" |
      .person.name = strenv(NAME)
  ' file.yaml`

- Find and update an item in an array
  `yq '(.[] | select(.name == "foo") | .address) = "12 cat st'`

- Convert JSON to YAML
  `yq -Poy sample.json`