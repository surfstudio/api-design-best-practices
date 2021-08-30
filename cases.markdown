
# API Design Cases

# Содержание 
- [API Design Cases](#api-design-cases)
- [Содержание](#содержание)
- [Кейсы](#кейсы)
  - [Именование пути запроса](#именование-пути-запроса)
  - [Параметры запроса](#параметры-запроса)
  - [Тело запроса](#тело-запроса)
  - [Ответ](#ответ)
  - [Общие моменты](#общие-моменты)

# Кейсы
## Именование пути запроса
- Не пишите действие в названии пути, о котором говорит HTTP method (create, update, delete и тд). Используйте HTTP методы для CRUD операций. В этом и есть их смысл. 
  - GET: получение данных о ресурсах.
  - POST: создание новых ресурсов и подресурсов.
  - PUT: обновление существующих ресурсов.
  - PATCH: обновляет только определённые поля существующих ресурсов.
  - DELETE: удаляет ресурсы.
  <table border="1" width="100%" cellpadding="5">
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td><code>POST /courses/create</code> - Создать новый курс </td>
    <td><code>POST /courses</code> - Создать новый курс</td>
    </tr>
  </table>
- Используйте kebab-case для URL
  <table border="1" width="100%" cellpadding="5">
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td><code>/systemOrders</code> <br/><code>/system_orders</code> </td>
    <td><code>/system-orders</code></td>
    </tr>
  </table>
- Используйте простой порядковый номер для версий и всегда указывайте его на самом верхнем уровне.
  <table border="1" width="100%" cellpadding="5">
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td></td>
    <td><code>http://myproject.com/v1/shops/3/products</code></td>
    </tr>
  </table>
- Используйте множественное число для коллекций
  <table border="1" width="100%" cellpadding="5">
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td><code>GET /user</code> <br/><code>GET /User</code> </td>
    <td><code>GET /users</code></td>
    </tr>
  </table>
- URL должен начинаться с коллекции и заканчиваться идентификатором
  <table border="1" width="100%" cellpadding="5">
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td><code>GET /shops/{shopId}/category/{categoryId}/price</code> <br/>Такой вариант плох тем, что указывает на свойство вместо ресурса</td>
    <td><code>GET /shops/{shopId}/ или GET /category/{categoryId}</code></td>
    </tr>
  </table>
- Не используйте глаголы в URL ресурсов. Вместо этого пользуйтесь HTTP методами для описания операций.
  <table border="1" width="100%" cellpadding="5">
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td><code>POST /updateuser/{userId}</code> <br/><code>GET /getusers</code></td>
    <td><code>PUT /user/{userId}</code></td>
    </tr>
  </table>
- Пользуйтесь глаголами в URL операций.
  <table border="1" width="100%" cellpadding="5">
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td></td>
    <td><code>POST /alerts/245743/resend</code> <br/>Помните, что resend не является CRUD операцией. Наоборот, это функция, которая выполняет определённое действие на сервере.</td>
    </tr>
  </table>

## Параметры запроса
- Не декларируйте объекты в параметрах запроса
  <table border="1" width="100%" cellpadding="5" >
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td valign="top"> 

    ```yaml
    parameters:
          - name: q
            in: query
            required: true
            schema:
              type: object
              properties:
                name:
                  type: string
    ```
    </td>
    <td valign="top">
    
    ```yaml
    parameters:
          - name: q
            in: query
            required: true
            schema:
              type: string
    ```
    Если все же необходим объект, то объявите его в моделях и ссылайтесь на данный объект
    ```yaml
    parameters:
          - name: q
            in: query
            required: true
            schema:
              $ref: "models.yaml#/components/schemas/Report"
    ```
    Можно вынести отдельно параметры для дальнейшего переиспользования и ссылаться на объявленные параметры
    ```yaml
    parameters:
          - $ref: "models.yaml#/components/parameters/Param1"
    ```
    </td>
    </tr>
  </table>  
## Тело запроса
- Всегда ставьте ссылки на модели. Не нужно засорять нашу спецификацию перечислением того, что должно быть в моделях. У нас и так огромные методы, а если еще модели писать, то будет много дублирования и иных проблем. Делаем ссылки для своего удобства и для удобства всей команды. ***Есть исключения в виде массивов или групп, в таком случае мы прописываем массив и как тип элементов, которые там лежат мы используем ссылку на модель элемента***
  <table border="1" width="100%" cellpadding="5" >
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td valign="top"> 

    ```yaml
    requestBody: 
      required: true
      content:
        application/json: 
          schema:
            type: object
            properties:
              name:
                type: string
              id:
                type: string
    ```
    </td>
    <td valign="top">
    
    ```yaml
    requestBody: 
      required: true
      content:
        application/json: 
          schema:
            $ref: "models.yaml#/components/schemas/RecalculateOrderRequest"
    ```
    ```yaml
    requestBody: 
      required: true
      content:
        application/json: 
          schema:
            type: array
            items:
              $ref: "models.yaml#/components/schemas/RecalculateOrderRequest"
    ```
    </td>
    </tr>
  </table>  

## Ответ
- Аналогично телу запроса. Всегда ставьте ссылки на модели, не дакларируйте объекты в ответе.
  <table border="1" width="100%" cellpadding="5" >
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td valign="top"> 

    ```yaml
    responses:
        '200':
          description: Все ок
          $ref: "models.yaml#/components/schemas/Response" 
    ```
    ```yaml
    responses:
        '200':
          description: Все ок
          content:
            application/json: 
              schema:
                type: object
                properties:
                  name:
                    type: string
                  id:
                    type: string
    ```
    </td>
    <td valign="top">
    
    ```yaml
    responses:
        '200':
          description: Все ок
          content:
            application/json: 
              schema: $ref: "models.yaml#/components/schemas/Response" 

    ```
    </td>
    </tr>
  </table>
- Указывайте количество ресурсов в ответе на запрос
  <table border="1" width="100%" cellpadding="5" >
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td valign="top"> 

    ```json
    {
      users: [], 
      offset: 0
    }
    ```
    </td>
    <td valign="top">
    
    ```json
    {
      users: [], 
      offset: 0,
      total: 34
    }
    ```
    </td>
    </tr>
  </table>

## Общие моменты
- Пишите описание к методам API и моделям, используя свойство description и summary. Описывайте там задачу которую решает метод или свойство. 
  <table border="1" width="100%" cellpadding="5">
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td valign="top">

    ```yaml
    paths:

      /search:
        get:
          summary: Поиск с постраничной пагинацией    
          parameters:
            - name: query
              in: query
              required: true
              schema:
                type: string
            - $ref: "../../common/parameters.yaml#/components/Limit"
            - $ref: "../../common/parameters.yaml#/components/Offset"
          responses:
            "200":
              description: >
                Успешный ответ.  
              content:
                "application/json":
                  schema:
                    type: array
                    items:
                      $ref: "models.yaml#/components/schemas/SearchItem"
            "500":
              description: Что-то сломалось на сервере.
              content:
                "application/json":
                  schema:
                    $ref: "../../common/errors.yaml#/components/schemas/CommonError"
    ```
    </td>
    <td valign="top">

    ```yaml
    paths:

      /search:
        get:
          summary: Поиск с постраничной пагинацией
          description: >
            Выполняет поиск по запросу заданному в `query`.
            Пагинация работает следующим образом:
            -> Первый запрос:
              query = "Яблоки"
              limit = 10
              offset = 0
            Сервер вернул 10 элементов
            -> Второй запрос:
            query = "Яблоки"
            limit = 10
            offset = 10
            Сервер вернул 5 элементов --> нашлось только 15 элементов. Пагинация закончилась. 
            Каждый параметр отдельно описан.      
          parameters:
            - name: query
              in: query
              description: Содержит запрос по которому будет выполняться поиск
              required: true
              schema:
                type: string
            - $ref: "../../common/parameters.yaml#/components/Limit"
            - $ref: "../../common/parameters.yaml#/components/Offset"
          responses:
            "200":
              description: >
                Успешный ответ. 
                **ВАЖНО**
                Может содержать пустой массив -- тем самым обозначать то, что пагинация закончилась.
                Так же, вам нужно будет самим уточнить у вашего бэка какие могут быть ошибки и как их нужно обрабатывать. 
              content:
                "application/json":
                  schema:
                    type: array
                    items:
                      $ref: "models.yaml#/components/schemas/SearchItem"
            "500":
              description: Что-то сломалось на сервере.
              content:
                "application/json":
                  schema:
                    $ref: "../../common/errors.yaml#/components/schemas/CommonError"
    ```
    </td>
    </tr>
  </table>
- Используйте camelCase для JSON свойств
  <table border="1" width="100%" cellpadding="5" >
    <tr>
      <th>Плохо</th>
      <th>Хорошо</th>
    </tr>
    <tr>
    <td valign="top"> 

    ```json
    {
      user_name: "Васька Петров",
      user_id: "1"
    }
    ```
    </td>
    <td valign="top">
    
    ```json
    {
      userName: "Васька Петров",
      userId: "1"
    }
    ```
    </td>
    </tr>
  </table>