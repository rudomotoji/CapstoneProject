export function parseJwt (token) {
  var base64Url = token.split('.')[1]
  var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
  var jsonPayload = decodeURIComponent(atob(base64).split('').map(function (c) {
    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
  }).join(''))

  return JSON.parse(jsonPayload)
}
export function formatPrice (price, char) {
  var length = price.toString().length + 1
  var tmpPrice = price.toString().split('').reverse().join('')
  var finalPrice = ''
  for (let index = 1; index < length; index++) {
    if (index % 3 !== 0) {
      finalPrice = finalPrice + tmpPrice[index - 1]
    } else {
      finalPrice = finalPrice + tmpPrice[index - 1] + char
    }
  }
  finalPrice = finalPrice.split('').reverse().join('')
  if (finalPrice[0] === char) {
    finalPrice = finalPrice.substring(1)
  }
  return finalPrice
}
export function toPriceWord (price, char) {
  // var tmpPriceNoSpecChar = (price + '').replace(/[^a-zA-Z ]/g, '') // Xoá ký tự đặc biệt
  var priceArr = price.split(char) // cắt price thành từng chuỗi
  var priceLength = priceArr.length // Độ dài chuỗi price
  for (let index = 0; index < priceLength; index++) {
  }
}
// Thursday, 18/03/2021
export function toDateTitle (dateStr) {
  var weekDay = dateStr.split(',')[0].trim()
  var date = dateStr.split(',')[1].trim().split('/').reverse().join('/') // Convert 18/03/2021 to 2021/03/18
  const now = new Date() // Ngày hiện tại
  var day = now.getDate() < 10 ? `0${now.getDate()}` : now.getDate() // Thêm 0 phía trước nếu số có 1 chữ số
  var month = (now.getMonth() + 1) < 10 ? `0${now.getMonth() + 1}` : now.getMonth() + 1 // Thêm 0 phía trước nếu số có 1 chữ số
  var year = now.getFullYear()
  var dateNow = `${year}/${month}/${day}` // Ngày hiện tại 2021/03/18

  switch (weekDay) {
    case 'Monday':
      if (dateNow === date) {
        weekDay = 'Hôm nay'
      } else {
        weekDay = 'Thứ hai'
      }
      break
    case 'Tuesday':
      if (dateNow === date) {
        weekDay = 'Hôm nay'
      } else {
        weekDay = 'Thứ ba'
      }
      break
    case 'Wednesday':
      if (dateNow === date) {
        weekDay = 'Hôm nay'
      } else {
        weekDay = 'Thứ tư'
      }
      break
    case 'Thursday':
      if (dateNow === date) {
        weekDay = 'Hôm nay'
      } else {
        weekDay = 'Thứ năm'
      }
      break
    case 'Friday':
      if (dateNow === date) {
        weekDay = 'Hôm nay'
      } else {
        weekDay = 'Thứ sáu'
      }
      break
    case 'Saturday':
      if (dateNow === date) {
        weekDay = 'Hôm nay'
      } else {
        weekDay = 'Thứ bảy'
      }
      break
    case 'Sunday':
      if (dateNow === date) {
        weekDay = 'Hôm nay'
      } else {
        weekDay = 'Chủ nhật'
      }
      break
    default: break
  }
  // Return Thursday, 18/03/2021 nếu ngày khác Hôm nay
  return weekDay === 'Hôm nay' ? weekDay : `${weekDay}, ${date.split('/').reverse().join('/')}`
}

// minutes ago . Chuyển đổ thời gian hiển thị thông báo
export function toTimeAgo (time) {
  const minuteTime = parseInt(time) // Số phút
  const hourTime = parseInt(minuteTime / 60) // Số giờ
  const dateTime = parseInt(hourTime / 24) // Số ngày
  const monthTime = parseInt(dateTime / 30) // Số tháng
  const yearTime = parseInt(dateTime / 365) // Số năm

  var timeAgo = '' // Thời gian hiển thị cách đây

  if (yearTime >= 1) {
    timeAgo = `${yearTime} năm trước`
  } else {
    if (monthTime < 12) {
      if (dateTime < 30) {
        if (hourTime < 24) {
          if (minuteTime < 60) {
            timeAgo = `${minuteTime} phút trước`
          } else {
            timeAgo = `${hourTime} giờ trước`
          }
        } else {
          timeAgo = `${dateTime} ngày trước`
        }
      } else {
        timeAgo = `${monthTime} tháng trước`
      }
    } else {
      timeAgo = `${yearTime} năm trước`
    }
  }
  return timeAgo
}
export function formatDateToInsertDb (date) {
  var dateInsert = new Date(date)
  return `${dateInsert.getFullYear()}-${dateInsert.getMonth() + 1 < 10 ? '0' + (dateInsert.getMonth() + 1) : (dateInsert.getMonth() + 1)}-${dateInsert.getDate() < 10 ? '0' + dateInsert.getDate() : dateInsert.getDate()}`
}
export function groupBy (array, key, keyName, keyCollection) {
  const tmpArr = array.reduce((objectsByKeyValue, obj) => {
    const value = obj[key]
    objectsByKeyValue[value] = (objectsByKeyValue[value] || []).concat(obj)
    return objectsByKeyValue
  }, {})
  const keys = Object.keys(tmpArr)
  const values = Object.values(tmpArr)
  var groupByArr = []
  for (let index = 0; index < keys.length; index++) {
    const element = {
      [keyName]: keys[index],
      [keyCollection]: values[index]
    }
    groupByArr.push(element)
  }
  return groupByArr
} // Convert array to groupBy array other {key, collections}
