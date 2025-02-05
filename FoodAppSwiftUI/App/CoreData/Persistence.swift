import CoreData

//MARK: - Core Data'yı yöneten bir Persistence Controller oluşturur.
struct PersistenceController {
    static let shared = PersistenceController()

    
    ///test ve preview amaçları için kullanışlıdır.
    static var preview: PersistenceController = {
        
        ///CoreData'nun hafızada çalışmasını sağlar, yani uygulama kapandığında bu veriler kaybolur
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            /// MARK: Core data'daki timestamp değişkenine Date() yani günümüz tarihi atanıyor.
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        
        
        /// MARK: Burada veri Core data'ya kaydediliyor, ve hata durumları kontrol ediliyor.(viewContext = NSManagedObjectContext)
        do {
            
            /// viewContext.save() çağrısı ile eklenen veriler Core Data'ya kaydedilir.
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    /// MARK: Core Data için bir kalıcı veri yönetim (persistence) katmanı oluşturur ve veri saklama işlemlerini yönetir.
    /// inMemory parametresi, verilen hafızada mı tutulacağını yoksa kalıcı olaraktan saklanacağını mı belirler.
    /// Varsayılan olarak false olduğu için gerçek bir Core Data veritabanı kullanılır.
    init(inMemory: Bool = false) {
        
        ///MARK: Yummie adında bir Core Data veritabanı (persistent store)  oluşturur.
        /// Bu, xcdatamold dosyanızda tanımlı olan veri modelinin adıyla eşleşmelidir.
        container = NSPersistentContainer(name: "Yummie")
        
        // Eğer inMemory true ise, veritabanı diske yazılmaz, bunun yerine /dev/null içine yönlendirir.
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        ///MARK: loadPersistentStores çağrısı, Core Data'nın veritabanını yüklemesini sağlar.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                ///Not: fatalError() gerçek bir uygulamada kullanılmamalıdır çünkü uygulamayı anında çökertir. Bunun yerine hataları yönetmek için bir do-catch bloğu kullanılabilir.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        ///MARK: - Değişikliklerin otomatik olaraktan birleştirilmesi
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
