owl-viewer
==========

## 使用说明

### 打包 js

```
coffee --join js/ontology.js --compile js/model/base/*.coffee js/model/*.coffee js/*.coffee
```

### 启动 http 服务

```
  cd owl-viewer
  ruby -run -e httpd . -p 9527
```

### 访问服务

浏览器访问 http://yourhost:9527/index.html