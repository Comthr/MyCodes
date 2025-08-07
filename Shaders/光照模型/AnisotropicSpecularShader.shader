Shader "ShaderCaseStudy/Ch03/Anisotropic"
{
    Properties
    {
        _MainTint("Diffuse Tint",Color) = (1,1,1,1)
        _MainTex("Base (RGB)",2D) = "white"{}
        _SpecularColor("Specular Color",Color)= (1,1,1,1)
        _SpecularAmount("Specular Amount",Range(0,1)) =0.5
        _SpecularPower("Specular Power",Range(0,1)) =0.5
        _AnisoDir("Anisotropic Direction",2D) = ""{}
        _AnisoOffset("Anisotropic Offset",Range(-1,1)) = -0.2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf AnisotropicSpec

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_AnisoDir;
        };

        sampler2D _MainTex;
        sampler2D _AnisoDir;
        float4 _MainTint;
        float4 _SpecularColor;
        float _AnisoOffset;
        float _SpecularAmount;
        float _SpecularPower;

        struct SurfaceAnisoOutput
        {
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 AnisoDirection;
            half Specular;
            fixed Gloss;
            fixed Alpha;
        };


        void surf (Input IN, inout SurfaceAnisoOutput o)
        {
             half4 c = tex2D(_MainTex,IN.uv_MainTex)*_MainTint;
             //将纹理(0,1)映射到(-1,1)的向量信息
             float3 anisoTex = UnpackNormal(tex2D(_AnisoDir,IN.uv_AnisoDir));
             o.AnisoDirection = anisoTex;
             o.Specular = _SpecularAmount;
             o.Gloss = _SpecularPower;
             o.Albedo = c.rgb;
             o.Alpha = c.a;
        }

        fixed4 LightingAnisotropicSpec(SurfaceAnisoOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
        {
            //半矢量近似反射角
            fixed3 halfVector = normalize(lightDir+viewDir);

            //diffuse
            //saturate夹取(0,1)
            float NdotL = saturate(dot(s.Normal,lightDir));
            fixed3 diffuse = s.Albedo*_LightColor0.rgb*NdotL*atten;

            //specular
            //根据贴图给的发现偏移得到想要的法线，然后对反射角点乘求角度
            fixed HdotA = dot(normalize(s.Normal+s.AnisoDirection),halfVector);
            //给角度加个offset之后，使用sin函数制造一个非线性的值
            float aniso = max(0,sin(radians((HdotA+_AnisoOffset)*180)));
            //加上高光的强度
            float spec = saturate(pow(aniso,s.Gloss*128)*s.Specular);
            fixed3 specular = _LightColor0.rgb*_SpecularColor.rgb*atten*spec;

            fixed4 c;
            c.rgb = diffuse + specular ;
            c.a =s.Alpha;
            return c;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
