# App structure

The app main screen is structured like this

```
-----------------------------------
|   ScrollView                    | This allows scrolling
|---------------------------------|                                
| UIView holding StackView        | This allows the UIView to size height automatically base on the StackView's contents
| ------------------------------- |
|  CustomCard: StackView          | This is the individual cards. It sizes height automatically
|                                 |
|                                 |
|                                 |
|                                 |
|                                 |
|                                 |
| ------------------------------- |                                
|  CustomCard: StackView          |
|                                 |
|                                 |
|                                 |
|                                 |
|                                 |
|                                 |
| ------------------------------- |                                
|   CustomCard: StackView         |
|                                 |
|                                 |
|                                 |
|                                 |
|                                 |
|                                 |
|                                 |
|---------------------------------|                                
-----------------------------------
```

The data from the server flows like this

Data -> ServiceManager -> MainViewModel -> MainViewController

The MainViewController creates a CustomCard for each element in the array returned from the backend

Each CustomCard then makes a network call to fetch their individual image

ImageData -> ServiceManager -> CustomCardViewModel -> CustomCardViewController

