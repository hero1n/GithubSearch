Github user search iOS App
========
![Screenshot](./Screenshot.png)
#### Username 기준으로 검색시 프로필 사진, 유저 이름과 Public repo 갯수가 보여집니다.
##### Infinite scroll로 더 조회가 가능합니다. (한번 조회시 최대 20)

- - -

### Github token
Constants/Constants.swift 에서 Personal access token을 등록해야 검색 Limit에 걸리지 않습니다

```
struct BasicConstants {
    // OAuth token
    static let GITHUB_TOKEN: String = ""
}
```
