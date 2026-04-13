from flask import Flask, request, jsonify
import mysql.connector


app = Flask(__name__)
@app.route('/Usuario', methods=['POST'])
def crear_usuario():
    datos = request.get_json()
    db =  "" #CONEXION BASE DE DATOS
    cursor = db.cursor()
    nombre = datos.get('nombre')
    email = datos.get('email')
    crear = "INSERT INTO usuario(nombre, email) VALUES (%s, %s)"
    repetido = "SELECT id FROM usuario WHERE email = %s"
    #Manejo de Errores
    if not nombre or not email:
        return jsonify ({"error":"Es necesario un nombre o email"}), 404
    elif not isinstance(nombre, str):
        return jsonify ({"error":"El nombre no es valido"}), 400
    elif not isinstance(email, str):
        return jsonify ({"error":"El email no es valido"}), 400
    #Condicion para el email Repetido
    cursor.execute(repetido,(email,))
    resultado = cursor.fetchone()
    if resultado is not None:
        return jsonify ({"error":"El email ya esta en la lista"}), 409
    #creacion de usuario
    cursor.execute(crear,(nombre,email))
    db.commit()
    nuevo_id = cursor.lastrowid
    return jsonify ({
        "mensaje": "Usuario creado con exito",
        "id": nuevo_id,
        "nombre": nombre,
        "email": email
    }), 201