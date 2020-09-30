const { Backend } = require('../../kuzzle')
const https = require('https')
const parser = require('xml2json')

const getStations = () => {
  return new Promise((resolve, reject) => {
    https.get('https://data.montpellier3m.fr/sites/default/files/ressources/TAM_MMM_VELOMAG.xml',
    res => {
      let body = '';
      res.on('data', (chunk) => (body += chunk.toString()));
      res.on('error', reject);
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode <= 299) {
          resolve(parser.toJson(body, {
            coerce: true,
            object: true
          }))
        } else {
          reject('Request failed. status: ' + res.statusCode + ', body: ' + body)
        }
      })
    })
  })
}

const app = new Backend('bike-stations')

app.controller.register('bike-stations', {
  actions: {
    get: {
      handler: () => getStations()
    }
  }
})

app.start().then(async () => {
  setInterval(async () => {
    const res = await getStations()
    app.sdk.realtime.publish('bike-stations', 'stations', res)
  }, 60000)
}).catch(err => {
  console.error(err)
})