//
//  DemoPosts.swift
//  Navigation
//
//  Created by Павел Барташов on 19.06.2022.
//

import UIKit

extension Post {
    public static var demoPosts: [Post] {
        [Post(url: "1",
              author: "HeadHunter",
              description: "Сублимация попыток объяснить друзьям чем отличаются классы от протоколов и почему без организации целого концерта здесь никак не обойтись.",
              image: UIImage(named: "postImage-1"),
              likes: 10,
              views: 15),

         Post(url: "2",
              author: "swiftuinotes",
              description: "Если вы нашли и читаете данную статью, значит пришли к пониманию необходимости тестов в вашем приложении, а это залог качества написанного вами кода и забота о клиентах. И всё же, зачем нужны тесты? Опишу самые, на мой взгляд, важные причины.",
              image: UIImage(named: "postImage-2"),
              likes: 167,
              views: 789),

         Post(url: "3",
              author: "Dino2005",
              description: "Жизненный цикл UIViewController",
              image: UIImage(named: "postImage-3"),
              likes: 560,
              views: 861),

         Post(url: "4",
              author: "trucoruva",
              description: "Нормализация сна и суточных ритмов – востребованная нынче тема. Согласитесь, удобно иметь на смартфоне приложение, способное за пару свайпов обеспечить здоровый сон, исправить суточные ритмы после перелёта или купировать эффекты, связанные с утомлением-переработкой-стрессом. Спрос рождает предложение – и вот уже YouTube ломится от разного рода «музык для релаксации», «сеансов гипноза» и «исцеления во время сна 432 Гц». А Google Play и App Store, соответственно, от генераторов белого шума, плееров с треками для засыпания, смарт-будильников, интеллектуальных светильников, сервисов для подсчёта медленноволнового сна и прочего биохакерского мусора. Есть ли в подобных приложениях рациональное зерно? Да. безусловно. Но мы не станем перелопачивать народное творчество в поисках жемчужных зёрен, а начнём с правильной постановки задачи и определения технического облика акустического стимулятора на основе имеющихся гипотез. Ведь правильно поставленный вопрос содержит в себе половину ответа, не так ли?",
              image: UIImage(named: "postImage-4"),
              likes: 1105,
              views: 8946)
        ]
    }
}
