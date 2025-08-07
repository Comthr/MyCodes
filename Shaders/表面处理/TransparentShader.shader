Shader "ShaderCaseStudy/Ch02/TransparentShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent"  //��ǵ�ǰ����Ϊ͸�����Ͳ���
            "IgnoreProjector" = "True"  //����Projector�����Ӱ��
            "Queue" = "Transparent"     //��Ⱦ��������Ϊ"Transparent"
        }
        Cull Off                       //���������εı����޳�
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alpha:fade//����͸������Ⱦģʽ

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };
        sampler2D _MainTex;
        fixed4 _Color;
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
