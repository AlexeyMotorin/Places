#  app Places

## about Places

Программа позволяет добавлять и удалять места в которых побывал пользователь.
В программе предусмотрено добавление фото, система оценки места, отображение места на карте, построение маршрута.

* верстка кодом (UIKIT)
* Auto Layout
* NavigationController (push/pop)
* TableView
* CustomTableCell
* ImagePicker
* Alert
* базовые UI коммпоненты (UILabel, UITextField, UIImageView и проч.)
* UISearchController
* RealmSwift
* MapKit

## **Дизайн проекта:**
<img src="https://github.com/Pussmal/Places/blob/main/Screen1-3.jpg?raw=true" height="700"/></h1>
<img src="https://github.com/Pussmal/Places/blob/main/Screen4-5.jpg?raw=true" height="700"/></h1>
<img src="https://github.com/Pussmal/Places/blob/main/Screen6-8.jpg?raw=true" height="700"/></h1>

## **В проекте применяется:**
* Адаптивная верстка экранов;
* Использование сторонней библиотеки c cocoapods
* Использование и настройка визуальных компонентов;
* Использование UITableView, Customcell, Realm, Codable, UISearchController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, MapKit, CoreLocation, UIAlertController, UITapGestureRecognizer

## **Требования к проекту:**
1. Вся вёрстка приложения кодом, без xib и storyboard
2. верстка через Auto Layout
3. UIKit
4. Использование сторонней библиотеки Cocoa Pods

## **Что сделано:**
* Стартовый экран – таблица со списком добавленных.  Список редактируется, фильтруется. сортируется по имени и дате. 
* Добавления места - image с камеры или с альбома, если невыбран, используется дефолтная картинка, адрес можно вставить через поиск себя на карте, реализована система оценки заведения
* Карты - можно найти свое текущее местоположение, реализованы отображения меток, возможность построения маршрута
*
