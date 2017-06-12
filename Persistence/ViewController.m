//
//  ViewController.m
//  Persistence
//
//  Created by Vasilii on 12.06.17.
//  Copyright © 2017 Vasilii Burenkov. All rights reserved.
//

#import "ViewController.h"
#import "FourLines.h"

static NSString * const kRootKey = @"kRootKey";

//@interface ViewController ()

//@end

//Мы добавляем в массив текст из каждого из четырех полей с помощью метода valueFourKey:, а затем записываем содержимое этого массива в файл списка свойств. Вот, собственно, и все.
//После загрузки нашего основного представления мы пытаемся найти файл списка свойств. Если он существует, то копируем из него данные в поля редактирования. Затем регистрируемся на получение уведомления о переходе приложения в неактивное состояние (либо в результате завершения работы, либо перевода в фоновый режим). Когда это происходит, собираем значения из четырех полей редактирования, сохраняя их в изменяемом массиве, и записываем этот массив в список свойств.

@implementation ViewController

//метод, dataFilePath, возвращает полный путь нашего файла данных посредством определения местоположения каталога Documents и присоединения к его концу значения переменной kFilename. Этот метод должен вызываться из любого кода, который обеспечивает загрузку и сохранение данных.
- (NSString *) dataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//Константа NSDocumentDirectory означает, что мы ищем путь к каталогу Documents. Вторая константа, NSUserDomainMask, говорит о том, что мы хотим ограничить поиск “песочницей” нашего приложения.
    NSString *documentsDirectory = [paths objectAtIndex:0];//Хотя функция возвращает целый массив совпадающих путей, мы можем рассчитывать на то, что наш каталог Documents будет располагаться в позиции с индексом 0. Почему? Мы знаем, что только один каталог отвечает заданному нами критерию, поскольку каждое приложение имеет только один каталог Documents.
    //return [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    //возвращаем путь к файлу data.plist, расположенному в каталоге Documents нашего приложения, и мы сможем использовать переменную data для создания файла и выполнения операций чтения и записи.
    return [documentsDirectory stringByAppendingPathComponent:@"data.archive"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //проверяем, существует ли уже заданный файл данных. Если нет, то больше не пытаемся его загрузить. Если же такой файл существует, создаем экземпляр массива, заполняя его содержимым этого файла, а затем копируем объекты из этого массива в наши четыре поля редактирования. Поскольку массивы — это упорядоченные списки, копируя их в том же порядке, в каком мы их сохраняли, мы всегда получим в нужных полях нужные значения.
    NSString *filePath = [self dataPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        /*NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
        for (int i = 0; i < 4; i++) {
            UITextField *theFild = self.lineFields[i];
            theFild.text = array[i];
        }*/
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        FourLines *fourLines = [unarchiver decodeObjectForKey:kRootKey];
        [unarchiver finishDecoding];
        for (int i = 0; i < 4; i++) {
            UITextField *theField = self.lineFields[i]; theField.text = fourLines.lines[i];
        }
    }
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
                                            addObserver:self//получательн наш контроллер
                                            selector:@selector(applicationDidBecomeActive:)//метод ниже
                                                name:UIApplicationWillResignActiveNotification //имя уведомления которое хотим получить
                                                object:app];//это объект, от которого мы ожидаем получить уведомление.
}

//добавляем в массив текст из каждого из четырех полей с помощью метода valueFourKey:, а затем записываем содержимое этого массива в файл списка свойств.
- (void)applicationWillResignActive:(NSNotification *)notification {
    NSString *filePath = [self dataPath];
    /*NSArray *array = [self.lineFields valueForKey:@"text"];
    [array writeToFile:filePath atomically:YES];*/
    //параметр atomically предписывает этому методу записывать данные во вспомогательный файл, а не в заданный. Если запись в этот файл выполнилась успешно, вспомогательный файл будет скопирован по адресу, заданному первым параметром. Это более безопасный способ записи данных в файл, поскольку в случае, если приложение аварийно завершится во время сохранения
    
    FourLines *fourLines = [[FourLines alloc] init];
    fourLines.lines = [self.lineFields valueForKey:@"text"];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:fourLines forKey:kRootKey];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
