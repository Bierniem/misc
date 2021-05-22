#python cyphers
class ADFGVX():
    """
    polybius square followed by transposition
    """
class Affine():
    """
    monoalphabetic substitution cypher on a function (ax + b) % m on the letter indexes of the plaintext
    """
class Alberti():
    """
    polyalphabetic cipher from 1467
    fixed relational sliding alphabets with in ciphertext keys to convey indexing
    """
class Alphabet():
    """
    another name for a vigenere
    """
class AlphabetumKaldeorum():
    """
    glyph or rune cipher, common letters have multiple ciphers
    often used with additional meaningless glpyhs interspersed against frequency analysis
    """
class Arnold():
    """
    a special case of book cypher using Sir William Blackstone Commentaries on the Laws of England
    """
class AryabhataNumeration():
    """
    alphasyllabic numeral system based on sanskrit phonemes
    """
class Atbash():
    """
    special case of substitution cypher
    """
class AutoKey():
    """
    a variation on vigenere in which the infinite key begins with a primer and is followed by the plaintext
    the key likely contains common words/ngrams of the language
    """
class Bacon():
    """
    coding is done by text presentation rather than by generating ciphertext
    eg. typeface variations
    These variations are used in a special binary to character table
    """
class Beaufort():
    """
    a variation of vigenere with the top row in reverse alphabetic order
    """
class VariantBeaufort():
    """
    vigenere in reverse such that encryption is vigenere decryption and vice versa
    """
class Beale():
    """
    special case of book using a variant printing of the United States Declaration of Independence
    """
class Bifid():
    """
    polybius square followed by fractionation and then back into characters by the same polybius square
    """
class Book():
    """
    plaintext is encoded by location within an agreed upon text
    common in cicada 3301
    """
class ThomasBrierley():
    """
    masonic pigpen with 's' variation
    """
class Caesar():
    """
    alphabetic shift cypher
    """
class Chaocipher():
    """
    dynamic substitution similar to enigma
    """
class Copiale():
    """
    homophonic substitution cypher with many cyphertext characters mapping to few characters to foil frequency analysis
    """
class DRYAD():
    """
    authentication and numeric cyphering based on a short period code sheet
    """
class FourSquare():
    """
    polygraphic symmetric encrytption on digraphs
    omits q
    """
    def makeSquare(key):
        #generates a key square
        alph = [i for i in 'abcdefghijklmnoprstuvxyz']
        lkey = [i for i in key]
        lkey = set(lkey) #remove duplicates
        if 'q' in lkey: #remove q
            lkey.remove('q')
        for i in lkey:
            alph.remove(i)
        square = flatten([lkey,alph])
        return square

    def encrypt(keyA,keyB,plaintext):
        ciphertext = ''
        squares = [makeSquare(''),makeSquare(keyA),makeSquare(keyB)]
        digraphs = [[plaintext[i],plaintext[i+1]] for i in range(0,len(plaintext),2)]
        for i in digraphs:
            indexes = [squares[0].index(i[0]),squares[0].index(i[1])]
            #row column
            indexes = [[np.ceil(ind/5),ind % 5] for in indexes]
            #get cypher squares row column
            indA = [indexes[0][0],indexes[1][1]]
            indB = [indexes[1][0],indexes[0][1]]
            #convert to index
            indA = 5*indA[0] + indA[1]
            indB = 5*indB[0] + indB[1]
            ciphertext += squares[1][indA]
            ciphertext += squares[2][indB]            
        return ciphertext

    def decrypt(keyA,keyB,ciphertext):
        plaintext = ''
        squares = [makeSquare(''),makeSquare(keyA),makeSquare(keyB)]
        digraphs = [[ciphertext[i],ciphertext[i+1]] for i in range(0,len(cyphertext),2)]
        for i in digraphs:
            indA = squares[1].index(i[0])
            indB = squares[2].index(i[1])
            #row column
            indA = [np.ceil(indA/5),indA % 5]
            indB = [np.ceil(indB/5),indB % 5]
            #get plaintext row column
            pA = [indA[0][0],indB[1][1]]
            pB = [indB[1][0],indA[0][1]]
            #get index
            indA = pA[0]*5 + pa[1]
            indB = pB[0]*5 + pB[1]
            plaintext += squares[0][indA]
            plaintext += squares[0][indB]
        return plaintext

    def demo():
        #keys
        #text
        #encrypt
        #decrypt 

class Great():
class Grille():
class Hill():
class M94():
class MlecchitaVikapla():
class Nihilist():
class Null():
class Pigpen():
class Playfair():
class PoemCode():
class Polyalphabetic():
class PolybiusSquare():
class RailFence():
class Rasterschlussel44():
class Reihenschieber():
class Reservehandverfahren():
class Rot13():
class RunningKey():
class Scytale():
class Sheshach():
class StraddlingCheckerboard():
class Substitution():
    """alphabet substitution cipher"""
    def encrypt(plaintext,key):
        ciphertext = ''
        return ciphertext

    def decrypt(cyphertext,key):
        plaintext = ''
        for i in cyphertext:
            if i in key.keys():
                plaintext+=key[i]
            else:
                plaintext += i
        return plaintext
class TabulaRecta():
class TapCode():
class Transposition():
class Trifid():
class TwoSquare():
class VIC():
class Vigenere():
class Wadsworth():
class Wahlwort():