quit(0)

let a=9506141111
echo a

type
  NimXOR = object
    key: seq[uint8]
    rounds: int

proc initNimXOR(baseKey: string, rounds: int = 3): NimXOR =
  result.rounds = rounds
  result.key = newSeq[uint8](baseKey.len)
  for i in 0..<baseKey.len:
    result.key[i] = baseKey[i].uint8

proc rotateLeft(x: uint8, amount: int): uint8 {.inline.} =
  (x shl amount) or (x shr (8 - amount))

proc rotateRight(x: uint8, amount: int): uint8 {.inline.} =
  (x shr amount) or (x shl (8 - amount))

proc expandKey(self: NimXOR, length: int): seq[uint8] =
  result = newSeq[uint8](length)
  var 
    prevByte: uint8 = 0
    accumulator: uint8 = 0
  
  for i in 0..<length:
    let keyByte = self.key[i mod self.key.len]
    accumulator = accumulator xor keyByte
    prevByte = rotateLeft(prevByte xor keyByte, 3)
    result[i] = prevByte xor accumulator

proc decrypt*(self: NimXOR, encrypted: seq[uint8]): string =
  var data = encrypted
  let expandedKey = self.expandKey(encrypted.len)
  
  for round in countdown(self.rounds - 1, 0):
    for i in 0..<data.len:
      data[i] = rotateRight(data[i], round + 1)
    
    for i in 0..<data.len:
      var b = data[i]
      b = rotateLeft(b, 1)
      b = b xor expandedKey[i mod expandedKey.len]
      b = rotateRight(b, 3)
      data[i] = b
  
  result = newString(data.len)
  for i in 0..<data.len:
    result[i] = data[i].char

when isMainModule:
  let encryptedData = redacted;

  let key = "redacted"
  let rounds = 3
  var cipher = initNimXOR(key, rounds)
  let decrypted = cipher.decrypt(encryptedData)
  echo "Decrypted message: ", decrypted