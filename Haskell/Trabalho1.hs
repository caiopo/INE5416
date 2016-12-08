-- Aluno: Caio Pereira Oliveira - 15100724

module Shapes (Shape (Sphere, Spheroid, Cylinder, Cone, ConeBase),
    area, volume) where

data Shape = Sphere Float
           | Spheroid Float Float
           | Cylinder Float Float
           | Cone Float Float
           | ConeBase Float Float Float
     deriving Show


area :: Shape -> Float

area (Sphere radius) = area (Spheroid radius radius)

area (Spheroid a b)
    | b < a = 2 * pi * a^2 + ((pi * b^2) / (ecc a b)) *
        log((1 + ecc a b) / (1 - ecc a b))

    | b > a = 2 * pi * (a^2 + ((a * b) / (ecc a b)) * asin(ecc a b))

    | b == a = 4 * pi * b^2
    where
        ecc a b
            | b < a = sqrt((a^2 - b^2) / (a^2))
            | b > a = sqrt((b^2 - a^2) / (b^2))
            | b == a = 0

area (Cylinder radius height) = 2 * pi * radius * (radius + height)

area (Cone radius height) = pi * radius * (sqrt(radius^2 + height^2) + radius)

area (ConeBase radius1 radius2 height) = pi * radius1^2 + pi * radius2 +
    pi * (radius1 + radius2) * sqrt(height^2 + (radius1 - radius2)^2)


volume :: Shape -> Float

volume (Sphere radius) = volume (Spheroid radius radius)

volume (Spheroid a b) = (4 / 3) * pi * b * a^2

volume (Cylinder radius height) = pi * height * radius^2

volume (Cone radius height) = (1 / 3) * pi * height * radius^2

volume (ConeBase radius1 radius2 height) =
    (1 / 3) * pi * height * (radius2^2 + radius2^2 + radius1 * radius2)
