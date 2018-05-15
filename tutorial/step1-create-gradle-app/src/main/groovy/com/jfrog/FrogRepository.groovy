package com.jfrog

import org.springframework.stereotype.Repository

/**
 * Created by alexistual on 05/01/2016.
 */
@Repository
class FrogRepository {

    List<Frog> getAllFrogs() {
        [
                new Frog(name: 'SpiderFrog', year: 2017, quote: 'With great Software come great responsabilities', imageUrl: '/spider2.png'),
                new Frog(name: 'Froga', year: 2016, quote: 'May the frog be with you', imageUrl: '/jedi.png'),
                new Frog(name: 'Batfrog', year: 2015, quote: 'It\'s always darkest before the green shines', imageUrl: '/bat.png'),
                new Frog(name: 'Superfrog', year: 2014, quote: 'It\'s a bird, it\'s a plane, it\'s Superfrog', imageUrl: '/superfrog.png'),
                new Frog(name: 'James Frog', year: 2013, quote: 'The name\'s Frog, JFrog', imageUrl: '/jamesfrog.png'),
                new Frog(name: 'Froga', year: 2012, quote: 'May the frog be with you', imageUrl: '/jedi.png'),
                new Frog(name: 'The Frogfather', year: 2011, quote: 'Artifactory, an offer you can\'t refuse', imageUrl: '/frogfather.png'),
                new Frog(name: 'Frocky', year: 2010, quote: 'Yo Adrian, I build it!', imageUrl: '/frocky.png'),
                new Frog(name: 'Indiana Frog', year: 2009, quote: '', imageUrl: '/indy.png'),
                new Frog(name: 'Princess Bride', year: 2008, quote: 'You killed my build, prepare to die', imageUrl: '/mousq.png')
        ]
    }

}
