# export-maven-coordinates-action
GitHub Action that exports maven coordinates from the project's pom.xml file.

It provides following `env` variables:

* `POM_GROUP_ID`
* `POM_ARTIFACT_ID`
* `POM_VERSION`

## Usage example

Here is how this action could be used to run automated deployment only for snapshot versions:

```yml
steps:
  - name: Checkout...
    uses: actions/checkout@v2

  - name: Export Maven coordinates...
    uses: bootique-tools/export-maven-coordinates-action@v1

  - name: Set up JDK...
    if: contains(env.POM_VERSION, '-SNAPSHOT')
    uses: actions/setup-java@v1
    with:
      java-version: 1.8

  - name: Deploy...
    if: contains(env.POM_VERSION, '-SNAPSHOT')
    run: mvn clean deploy
```