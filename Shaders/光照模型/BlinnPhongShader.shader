Shader "ShaderCaseStudy/Ch03/BlinnPhongShader"
{
    Properties
    {
        _DiffuseTint ("Diffuse Tint", Color) = (1,1,1,1)
        _SpecularTint ("Specular Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecularPower("Specular Power",Range(0.1,30)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf CustomPhong

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        float4 _DiffuseTint;
        float4 _SpecularTint;
        float _SpecularPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _DiffuseTint;
            o.Albedo= c.rgb;
            o.Alpha = c.a;
        }
        half4 LightingCustomPhong(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
        {
            //Reflection
            float NdotL = max(0,dot(s.Normal,lightDir));
            float3 reflectionVector = reflect(-lightDir,s.Normal);
            // float3 LdotN = dot(lightDir,s.Normal)*s.Normal;
            // float3 reflectionVector = 2*LdotN-lightDir;
            //Specular
            float spec = pow(max(0,dot(reflectionVector,viewDir)),_SpecularPower);
            
            //Final effect
            fixed4 c;
            //漫反射+镜面反射
            float3 diffuse = s.Albedo*_LightColor0.rgb*NdotL*atten;
            float3 specular = _LightColor0.rgb*spec*atten*_SpecularTint.rgb;
            c.rgb = diffuse+specular;
            c.a = s.Alpha;
            return c;
        }
        //用半矢量代替反射向量，减少计算量，效果差不多
        fixed4 LightingCustomBlinnPhong2(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten)
        {
            float NdotL = dot(s.Normal,lightDir);
            float3 halfVector = normalize(lightDir+viewDir);
            float NdotH = max(0,dot(s.Normal,halfVector));

            float spec = pow(NdotH,_SpecularPower);
            fixed4 c;
            c.rgb = s.Albedo*_LightColor0.rgb*NdotL*atten+_LightColor0.rgb*_SpecularTint.rgb*spec*atten;
            c.a = s.Alpha;
            return c;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
