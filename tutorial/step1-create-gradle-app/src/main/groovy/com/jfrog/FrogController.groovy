package com.jfrog

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

/**
 * Created by alexistual on 05/01/2016.
 */
@RestController
@CrossOrigin(origins = "*")
class FrogController {

    @Autowired
    FrogRepository frogRepository
    @Value('${info.build.version}')
    String version

    @RequestMapping('/frogs')
    List<Frog> frogs() {
        frogRepository.allFrogs
    }

    @RequestMapping(path = '/version', produces = ['text/plain'])
    String version() {
        version
    }

}
