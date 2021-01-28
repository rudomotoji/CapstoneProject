import Cookies from 'js-cookie'

const tokenKey = 'hdr-key'
const userNameKey = 'username-key'

export function getToken () {
  return Cookies.get(tokenKey)
}

export function setToken (token) {
  return Cookies.set(tokenKey, token)
}

export function removeToken () {
  return Cookies.remove(tokenKey)
}

export function setUserNameKey (userName) {
  return Cookies.set(userNameKey, userName)
}

export function getUserNameKey () {
  return Cookies.get(userNameKey)
}

export function removeUserNameKey () {
  return Cookies.remove(userNameKey)
}
